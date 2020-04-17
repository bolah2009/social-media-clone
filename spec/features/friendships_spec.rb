# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Friendships', type: :feature do
  let(:thor) { FactoryBot.create(:user) }
  let(:hulk) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship, user_id: thor.id, friend_id: hulk.id) }

  it 'user can send invitation to another user' do
    sign_in thor
    visit user_path(hulk)
    expect do
      expect(page).to have_content hulk.name
      expect(page).to have_content 'Send Friend Request'
      click_button 'Send Friend Request'
      expect(page).to have_content 'Friend request sent'
      expect(page).to have_content 'Cancel Friend Request'
    end
  end

  it 'user can accept friend request' do
    friendship.save
    sign_in hulk
    visit user_path(thor)
    expect do
      expect(page).to have_content thor.name
      expect(page).to have_content 'Accept Friend Request'
      expect(page).to have_content 'Reject Friend Request'
      click_button 'Accept Friend Request'
      expect(page).to have_content 'Unfriend'
    end
  end

  it 'user can reject friend request' do
    friendship.save
    sign_in hulk
    visit user_path(thor)
    expect do
      click_button 'Reject Friend Request'
      expect(page).to have_content 'Send Friend Request'
    end
  end

  it 'user can undo the friendship' do
    friendship.confirm_friend
    sign_in thor
    visit user_path(hulk)
    expect do
      expect(page).to have_content 'Unfriend'
      click_button 'Unfriend'
      expect(page).to have_content 'Send Friend Request'
    end
  end
end
