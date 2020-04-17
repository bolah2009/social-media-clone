# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship, user_id: user.id, friend_id: other_user.id) }
  let(:friendship_params) { FactoryBot.attributes_for(:friendship, user_id: user, friend_id: other_user) }

  describe '#create' do
    context 'as an authenticated user can' do
      it 'send request to another user' do
        sign_in user
        expect do
          post :create, params: { friendship: friendship_params }
          expect(flash[:success]).to be_present
        end.to change(user.friendships, :count).by(1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        post :create, params: { friendship: friendship_params }
        expect(flash[:success]).not_to be_present
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        friendship.save
        expect do
          post :create, params: { friendship: friendship_params }
          expect(flash[:success]).not_to be_present
          expect(response).to redirect_to '/users/sign_in'
        end.to change(user.friendships, :count).by(0)
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user can' do
      it 'cancel sent friendship request' do
        sign_in user
        friendship.save
        expect do
          delete :destroy, params: { id: friendship.id }
        end.to change(user.friendships, :count).by(-1)
      end

      it 'reject pending friendship request' do
        sign_in other_user
        expect do
          delete :destroy, params: { id: friendship.id }
        end
      end

      it 'unfriend other user' do
        friendship.confirm_friend
        sign_in user
        expect do
          delete :destroy, params: { id: friendship.id }
        end.to change(user.friendships, :count).by(-1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        delete :destroy, params: { id: friendship.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        friendship.save
        expect do
          delete :destroy, params: { id: friendship.id }
          expect(response).to redirect_to '/users/sign_in'
        end.to change(user.friendships, :count).by(0)
      end
    end
  end

  describe '#update' do
    context 'as an authenticated user can' do
      it 'accept pending request from other user' do
        sign_in other_user
        friendship.save
        expect do
          patch :update, params: { id: friendship.id }
          expect(flash[:success]).to be_present
        end.to change(other_user.friendships, :count).by(1)
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        post :create, params: { friendship: friendship_params }
        expect(flash[:success]).not_to be_present
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        expect do
          post :create, params: { friendship: friendship_params }
          expect(flash[:success]).not_to be_present
          expect(response).to redirect_to '/users/sign_in'
        end.to change(user.friendships, :count).by(0)
      end
    end
  end

  describe '#pending' do
    context 'as an authenticated user' do
      it 'responds successfully' do
        sign_in user
        get :pending
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in user
        get :pending
        expect(response).to have_http_status '200'
      end
    end

    context 'as a guest' do
      it 'redirects to the sign-in page' do
        get :pending
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'returns a 302 response' do
        get :pending
        expect(response).to have_http_status '302'
      end
    end
  end
end
