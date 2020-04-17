# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let!(:comment) { FactoryBot.create(:comment, user: user, post: user.posts.first) }
  let(:comment_params) { FactoryBot.attributes_for(:comment, post_id: user.posts.first) }

  describe '#create' do
    context 'as an authenticated user' do
      it 'comment on a post' do
        sign_in user
        expect do
          post :create, params: { comment: comment_params }
          expect(flash[:success]).to be_present
          expect(response).to redirect_to posts_path
        end.to change(user.comments, :count).by(1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        post :create, params: { comment: comment_params }
        expect(flash[:success]).not_to be_present
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        post :create, params: { comment: comment_params }
        expect(flash[:success]).not_to be_present
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      it 'delete a comment' do
        sign_in user
        expect do
          delete :destroy, params: { id: comment.id }
          expect(flash[:success]).to be_present
        end.to change(user.comments, :count).by(-1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        delete :destroy, params: { id: comment.id }
        expect(flash[:success]).not_to be_present
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: comment.id }
        expect(flash[:success]).not_to be_present
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
