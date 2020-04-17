# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }

  describe '#index' do
    context 'when a user is authenticated' do
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

    context 'when a user is a guest' do
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

    context 'when a user is authenticated' do
      it 'adds a post' do
        sign_in user
        expect do
          post :create, params: { post: post_params }
        end.to change(user.posts, :count).by(1)
      end
    end

    context 'when a user is a guest' do
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

  describe '#destroy' do
    let!(:post) { FactoryBot.create(:post, user_id: user.id) }

    context 'when a user is authenticated' do
      it 'delete a post' do
        sign_in user
        expect do
          delete :destroy, params: { id: post.id }
        end.to change(user.posts, :count).by(-1)
      end

      it 'redirect to edit path for invalid content' do
        sign_in other_user
        expect do
          delete :destroy, params: { id: post.id }
        end.to change(user.posts, :count).by(0)
      end

      it 'redirect to root path for wrong users' do
        sign_in other_user
        expect do
          delete :destroy, params: { id: post.id }
          expect(response).to redirect_to root_path
        end.to change(user.posts, :count).by(0)
      end
    end

    context 'when a user is a guest' do
      it 'returns a 302 response' do
        delete :destroy, params: { id: post.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    describe '#update' do
      let(:post) { FactoryBot.create(:post, user_id: user.id) }
      let(:post_params) { FactoryBot.attributes_for(:post, content: 'Updated post') }
      let(:invalid_post_params) { FactoryBot.attributes_for(:post, content: '') }

      context 'when a user is authenticated' do
        it 'edit post' do
          sign_in user
          expect do
            patch :update, params: { post: post_params, id: post.id }
            expect(flash[:success]).to be_present
          end.to change(user.posts, :count).by(0)
        end

        it 'redirect to edit post for invalid content' do
          sign_in user
          expect do
            patch :update, params: { post: invalid_post_params, id: post.id }
            expect(flash[:warning]).to be_present
          end.to change(user.posts, :count).by(0)
        end
      end

      context 'when a user is a guest' do
        it 'returns a 302 response' do
          expect do
            patch :update, params: { post: post_params }
            expect(flash[:success]).not_to be_present
            expect(response).to have_http_status '302'
          end
        end

        it 'redirects to the sign-in page' do
          expect do
            patch :update, params: { post: post_params }
            expect(flash[:success]).not_to be_present
            expect(response).to redirect_to '/users/sign_in'
          end
        end
      end
    end
  end
end
