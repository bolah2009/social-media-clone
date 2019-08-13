# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
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

  describe '#create' do
    let(:post_params) { FactoryBot.attributes_for(:post) }
    context 'as an authenticated user' do
      it 'adds a post' do
        sign_in user
        expect do
          post :create, params: { post: post_params }
        end.to change(user.posts, :count).by(1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        post :create, params: { post: post_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        post :create, params: { post: post_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
