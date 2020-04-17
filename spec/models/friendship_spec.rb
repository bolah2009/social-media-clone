# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let!(:user_1) { FactoryBot.create(:user) }
  let!(:user_2) { FactoryBot.create(:user) }
  let(:valid_friendship) { FactoryBot.create(:friendship) }
  let(:friendship) { FactoryBot.build(:friendship, user_id: nil, friend_id: nil) }
  let(:friendship) { FactoryBot.build(:friendship, user_id: 1, friend_id: 1) }

  it 'is valid with a user and friend' do
    valid_friendship.valid?
    expect(valid_friendship.errors).to be_empty
  end

  it 'is invalid without a user' do
    friendship.valid?
    expect(friendship.errors[:user]).to include('must exist')
  end

  it 'is invalid without a friend' do
    friendship.valid?
    expect(friendship.errors[:friend]).to include('must exist')
  end

  it 'is invalid with same user and friend' do
    friendship.valid?
    expect(friendship.errors[:invalid_friendship]).to include("can't be friend with same user")
  end

  describe '#confirm_friend' do
    it 'create friendship for both sides' do
      friendship = user_1.friendships.build(friend_id: user_2.id)
      expect do
        friendship.save
        friendship.confirm_friend
        expect(user_1.friends).not_to be_empty
        expect(user_2.friends).not_to be_empty
        expect(friendship.confirmed).to be_truthy
      end.to change(described_class.all, :count).by(2)
    end
  end

  describe '#destroy_mutual' do
    it 'destroy the friendship from both sides' do
      friendship = user_1.friendships.build(friend_id: user_2.id)
      friendship.save
      friendship.confirm_friend
      expect do
        friendship.destroy_friendship
        expect(user_1.friends).to be_empty
        expect(user_2.friends).to be_empty
      end.to change(described_class.all, :count).by(-2)
    end
  end
end
