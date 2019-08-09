require 'rails_helper'

RSpec.feature "Posts", type: :feature do

  scenario "user sign in and creates a new post" do
    user = FactoryBot.create(:user)

    visit root_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      fill_in :post_content,  with: "Hi there!"
      click_button "Post"
      expect(page).to have_content "Post was successfully created"
      expect(page).to have_content "Hi there!"
    }.to change(user.posts, :count).by(1)
  end
end
