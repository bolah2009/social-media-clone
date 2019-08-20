# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:valid_friendship) { FactoryBot.create(:friendship) }
  let(:friendship) { FactoryBot.build(:friendship, user_id: nil, friend_id: nil) }

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

  let(:friendship) { FactoryBot.build(:friendship, user_id: 1, friend_id: 1) }
  it 'is invalid with same user and friend' do
    friendship.valid?
    expect(friendship.errors[:invalid_friendship]).to include("can't be friend with same user")
  end

  context '#confirm_friend' do
    let!(:user) { FactoryBot.create(:user, id: 1) }
    let!(:friend) { FactoryBot.create(:user, id: 2) }
    let!(:friendship) { FactoryBot.build(:friendship, user_id: user, friend_id: friend, confirmed: false) }
    it 'accepts friendship request from user' do
      friendship.save
      friendship.confirm_friend
      expect(friendship.confirmed).to be_truthy
    end
  end
end
