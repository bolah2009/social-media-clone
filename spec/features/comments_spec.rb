# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :feature do
  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post) { user.posts.first }

  before do
    sign_in user
    visit root_path
  end

  it 'user can write valid comments on posts' do
    expect do
      fill_in 'Write a comment...', match: :first, with: 'Yippee ki-yay'
      click_button 'comment-button', match: :first
      expect(page).to have_css '.alert-success'
      expect(page).to have_content 'Comment successfully created'
      expect(page).to have_content 'Yippee ki-yay'
    end.to change(user.comments, :count).by(1)

    expect do
      fill_in 'Write a comment...', match: :first, with: ''
      click_button 'comment-button', match: :first
      expect(page).to have_css '.alert-warning'
      expect(page).to have_content 'Comment not created'
    end.to change(user.comments, :count).by(0)
  end

  it 'user can delete comments' do
    expect do
      fill_in 'Write a comment...', match: :first, with: 'Yippee ki-yay'
      click_button 'comment-button', match: :first
      expect(page).to have_content 'Yippee ki-yay'
      find('.comment-delete').click
      expect(page).not_to have_content 'Yippee ki-yay'
    end.to change(user.comments, :count).by(0)
  end

  it "user can't delete other user comments" do
    fill_in 'Write a comment...', match: :first, with: 'Yippee ki-yay'
    click_button 'comment-button', match: :first
    expect(page).to have_content 'Yippee ki-yay'

    click_button 'Sign Out'

    sign_in other_user
    visit root_path

    expect do
      expect(page).to have_content 'Yippee ki-yay'
      expect(page).not_to find('.comment-delete')
    end
  end
end
