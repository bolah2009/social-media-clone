# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  describe '#index' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get :index
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in user
        get :index
        expect(response).to have_http_status '200'
      end
    end

    context 'as a guest' do
      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      it 'responds successfully' do
        sign_in user
        get :show, params: { id: other_user.id }
        expect(response).to be_successful
      end
    end
    context 'as an unauthorized user' do
      it 'redirects to the sign-in page' do
        get :show, params: { id: other_user.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
