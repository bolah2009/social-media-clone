# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Likes', type: :feature do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  scenario 'user can like and unlike posts' do
    sign_in other_user
    friendship = user.friendships.build(friend_id: other_user.id)
    friendship.confirm_friend
    visit root_path
    expect do
      find("[name='like-button']", match: :first).click
      expect(page).to have_css 'form.edit_like'
      find("form.edit_like [name='unlike-button']", match: :first).click
      expect(page).to_not have_css 'form.edit_like'
    end.to change(other_user.likes_given, :count).by(0)
  end
end
