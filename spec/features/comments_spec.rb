
require 'rails_helper'

RSpec.feature 'Comments', type: :feature do

  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post) { user.posts.first }

  before do
    visit root_path
    fill_in 'user_email',    with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
  end

  scenario "user can write comments on posts" do
    expect do
      fill_in "Write a comment...", match: :first, with: "Yippee ki-yay"
      click_button "comment-button", match: :first
      expect(page).to have_content "Yippee ki-yay"
    end.to change(user.comments, :count).by(1)
  end

  scenario "user can delete comments" do
    expect do
      fill_in "Write a comment...", match: :first, with: "Yippee ki-yay"
      click_button "comment-button", match: :first
      expect(page).to have_content "Yippee ki-yay"
      find(".comment-delete").click
      expect(page).to_not have_content "Yippee ki-yay"
    end.to change(user.comments, :count).by(0)
  end

  scenario "user can't delete other user comments" do

    fill_in "Write a comment...", match: :first, with: "Yippee ki-yay"
    click_button "comment-button", match: :first
    expect(page).to have_content "Yippee ki-yay"

    click_button "Sign Out"

    fill_in 'user_email',    with: other_user.email
    fill_in 'user_password', with: other_user.password
    click_button 'Log in'

    expect do
      expect(page).to have_content "Yippee ki-yay"
      expect(page).to_not find(".comment-delete")
    end
  end
end
