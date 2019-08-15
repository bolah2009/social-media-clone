# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let!(:like) { FactoryBot.create(:like, user: user, post: user.posts.first) }
  let(:like_params) { user.posts.first.id }

  describe '#create' do
    context 'as an authenticated user' do
      it 'like on a post' do
        sign_in user
        expect do
          post :create, params: { post_id: like_params }
          expect(response).to redirect_to posts_path
        end.to change(user.likes_given, :count).by(1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        post :create, params: { like: like_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        post :create, params: { like: like_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      it 'delete a like' do
        sign_in user
        expect do
          delete :destroy, params: { id: like.id }
        end.to change(user.likes_given, :count).by(-1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        delete :destroy, params: { id: like.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
