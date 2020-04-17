# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do
  let(:start_env_for_omniauth) do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '1234567',
      info: {
        email: 'ghost@example.com',
        name: 'Ghost Example',
        first_name: 'Ghost',
        last_name: 'Example',
        image: 'http://graph.facebook.com/1234567/picture?type=square'
      }
    )
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end

  describe '#facebook' do
    describe '#annonymous user' do
      context "when facebook email doesn't exist in the system" do
        before do
          start_env_for_omniauth
          get :facebook
          @user = User.where(email: 'ghost@example.com')
        end

        it { expect(@user).not_to be_nil }

        it 'creates authentication with facebook id' do
          authentication = @user.where(provider: 'facebook', uid: '1234567').first
          expect(authentication).not_to be_nil
        end

        it { expect be_user_signed_in }
        it { expect(response).to redirect_to root_path }
      end

      context 'when facebook email already exist in the system' do
        it 'redirects to sign up page' do
          start_env_for_omniauth
          FactoryBot.create(:user, email: 'ghost@example.com')
          get :facebook
          expect(response).to redirect_to new_user_registration_path
        end
      end
    end

    describe '#logged in user' do
      context "when user don't have facebook authentication" do
        before do
          start_env_for_omniauth
          user = FactoryBot.create(:user, email: 'user@example.com')
          sign_in user
          get :facebook
        end

        it 'adds facebook authentication to current user' do
          user = User.where(email: 'user@example.com').first
          expect(user).not_to be_nil
          fb_user = User.where(provider: 'facebook').first
          expect(fb_user).not_to be_nil
          expect(fb_user.uid).to eq('1234567')
        end

        it { expect be_user_signed_in }
        it { expect(response).to redirect_to root_path }
      end

      context 'when user already connect with facebook' do
        before do
          start_env_for_omniauth
          user = FactoryBot.create(:user, email: 'ghost@example.com')
          user.update(provider: 'facebook', uid: '1234567')
          sign_in user
          get :facebook
        end

        it 'does not add new facebook authentication' do
          user = User.where(email: 'ghost@example.com').first
          expect(user).not_to be_nil
          expect(User.where(provider: 'facebook').count).to be(1)
        end

        it { expect be_user_signed_in }
        it { expect(response).to redirect_to root_path }
      end
    end
  end
end
