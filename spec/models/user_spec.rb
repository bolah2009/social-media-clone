# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  let(:other_post) { FactoryBot.create(:post) }
  let(:friend_1) { FactoryBot.create(:user) }
  let(:friend_2) { FactoryBot.create(:user) }

  it 'is valid with a name, email, and password' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, email: 'test@example.com')
    user = FactoryBot.build(:user, email: 'test@example.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  describe '#posts' do
    it 'brings all posts' do
      expect(user.posts).to be_empty
      FactoryBot.create_list(:post, 3, user_id: user.id)
      expect(user.posts.count).to eq 3
    end
  end

  context '@comments' do
    it 'brings all comments' do
      expect(user.comments).to be_empty
      FactoryBot.create_list(:comment, 5, user_id: user.id, post_id: post.id)
      expect(user.comments.count).to eq 5
    end
  end

  describe '#likes_given' do
    it 'brings all likes given' do
      expect(user.likes_given).to be_empty
      FactoryBot.create_list(:like, 75, user_id: user.id, post_id: post.id)
      expect(user.likes_given.count).to eq 75
    end
  end

  describe '#friends' do
    it 'brings all friends' do
      expect(user.friends).to be_empty
      user.friendships.create(friend_id: friend_1.id).confirm_friend
      expect(user.friends).not_to be_empty
      user.friendships.create(friend_id: friend_2.id).confirm_friend
      expect(user.friends.count).to eq 2
    end
  end

  describe '#pending_requests' do
    it 'brings all pending_requests as Friendship model' do
      expect(user.pending_requests).to be_empty
      friend_1.friendships.create(friend_id: user.id)
      friend_2.friendships.create(friend_id: user.id)
      expect(user.pending_requests.count).to eq 2
      expect(user.pending_requests.first).to be_a Friendship
      expect(user.pending_requests.second).to be_a Friendship
    end
  end

  describe '#pending_friends' do
    it 'brings all pending requests as User model' do
      expect(user.pending_friends).to be_empty
      friend_1.friendships.create(friend_id: user.id)
      friend_2.friendships.create(friend_id: user.id)
      expect(user.pending_friends.count).to eq 2
      expect(user.pending_friends.first).to be_a described_class
      expect(user.pending_friends.second).to be_a described_class
    end
  end

  describe '#sent_requests' do
    it 'brings all sent request as Friendship model' do
      expect(user.sent_requests).to be_empty
      user.friendships.create(friend_id: friend_1.id)
      user.friendships.create(friend_id: friend_2.id)
      expect(user.sent_requests.count).to eq 2
      expect(user.sent_requests.first).to be_a Friendship
      expect(user.sent_requests.second).to be_a Friendship
    end
  end

  describe '#sent_friends' do
    it 'brings all sent requests as User model' do
      expect(user.sent_friends).to be_empty
      user.friendships.create(friend_id: friend_1.id)
      expect(user.sent_friends.count).to eq 1
      expect(user.sent_friends.first).to be_a described_class
    end
  end

  describe '#liked?' do
    it 'returns true if a user liked a specific post' do
      user.likes_given.create(post_id: post.id)
      expect(user.liked?(post)).to eq true
      expect(user.liked?(other_post)).to eq false
    end
  end

  describe '#sent_request?' do
    it 'returns true if a user sent request given a specific user' do
      user.friendships.create(friend_id: friend_1.id)
      expect(user.sent_request?(friend_1)).to eq true
      expect(user.sent_request?(friend_2)).to eq false
    end
  end

  describe '#pending_request?' do
    it 'returns true if a user receive request given a specific user' do
      friend_1.friendships.create(friend_id: user.id)
      expect(user.pending_request?(friend_1)).to eq true
      expect(user.pending_request?(friend_2)).to eq false
    end
  end

  describe '#friend?' do
    it 'returns true if a user has friendship confirmed with another user' do
      user.friendships.create(friend_id: friend_1.id).confirm_friend
      user.friendships.create(friend_id: friend_2.id)
      expect(user.friend?(friend_1)).to eq true
      expect(user.friend?(friend_2)).to eq false
    end
  end

  describe '#feed' do
    it 'return all posts from the user and his friends' do
      FactoryBot.create_list(:post, 7, user_id: user.id)
      FactoryBot.create_list(:post, 9, user_id: friend_1.id)
      FactoryBot.create_list(:post, 20, user_id: friend_2.id)
      user.friendships.create(friend_id: friend_1.id).confirm_friend
      expect(user.feed.count).to eq 16
    end
  end
end
