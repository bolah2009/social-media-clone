# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :feature do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:friendship) { FactoryBot.create(:friendship, user_id: user.id, friend_id: other_user.id) }

  it 'user can like and unlike posts' do
    friendship.confirm_friend
    sign_in other_user
    visit root_path
    expect do
      find("[name='like-button']", match: :first).click
      expect(page).to have_css 'form.edit_like'
      find("form.edit_like [name='unlike-button']", match: :first).click
      expect(page).not_to have_css 'form.edit_like'
    end.to change(other_user.likes_given, :count).by(0)
  end
end
