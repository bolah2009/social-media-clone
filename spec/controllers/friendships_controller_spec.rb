# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let(:friendships_params) { FactoryBot.attributes_for(:friendship, user_id: user_1, friend_id: user_2) }
  describe '#create' do
    context 'as an authenticated user can' do
      it 'send request to another user' do
        sign_in user_1
        expect do
          post :create, params: { friendship: friendships_params }
          expect(flash[:success]).to be_present
        end.to change(user_1.friendships, :count).by(1)
      end
    end
  end
end
