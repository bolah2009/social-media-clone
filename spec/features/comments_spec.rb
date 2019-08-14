# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Comments', type: :feature do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post) { user.posts.first }

  before do
    sign_in user
    visit root_path
  end

  scenario 'user can write comments on posts' do
    expect do
      fill_in 'Write a comment...', match: :first, with: 'Yippee ki-yay'
      click_button 'comment-button', match: :first
      expect(page).to have_content 'Yippee ki-yay'
    end.to change(user.comments, :count).by(1)
  end

  scenario 'user can delete comments' do
    expect do
      fill_in 'Write a comment...', match: :first, with: 'Yippee ki-yay'
      click_button 'comment-button', match: :first
      expect(page).to have_content 'Yippee ki-yay'
      find('.comment-delete').click
      expect(page).to_not have_content 'Yippee ki-yay'
    end.to change(user.comments, :count).by(0)
  end

  scenario "user can't delete other user comments" do
    fill_in 'Write a comment...', match: :first, with: 'Yippee ki-yay'
    click_button 'comment-button', match: :first
    expect(page).to have_content 'Yippee ki-yay'

    click_button 'Sign Out'

    sign_in other_user
    visit root_path

    expect do
      expect(page).to have_content 'Yippee ki-yay'
      expect(page).to_not find('.comment-delete')
    end
  end
end
