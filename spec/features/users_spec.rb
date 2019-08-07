require 'rails_helper'

RSpec.feature "Users", type: :feature do

  scenario "create a new user" do
    params = FactoryBot.attributes_for(:user)

    visit root_path

    click_link "Sign up"

    fill_in "Name",                  with: params[:name]
    fill_in "Email",                 with: params[:email]
    fill_in "Password",              with: params[:password]
    fill_in "Password confirmation", with: params[:password]

    expect {
      click_button "Sign up"
      expect(page).to have_content "Welcome! You have signed up successfully."
      expect(page).to have_content "All posts"
    }.to change(User.all, :count).by(1)
  end

  scenario "log in and user" do
    user = FactoryBot.create(:user)

    visit root_path

    fill_in "Email",     with: user.email
    fill_in "Password",  with: user.password

    click_button "Log in"

    expect(page).to have_content "Signed in successfully."
  end
end
