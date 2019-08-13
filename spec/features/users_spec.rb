# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  let(:params) { FactoryBot.attributes_for(:user) }
  scenario 'create a new user' do
    visit root_path

    fill_in 'new_user_name',                  with: params[:name]
    fill_in 'new_user_email',                 with: params[:email]
    fill_in 'new_user_password',              with: params[:password]
    fill_in 'new_user_password_confirmation', with: params[:password]

    expect do
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end.to change(User.all, :count).by(1)
  end

  let(:user) { FactoryBot.create(:user) }
  scenario 'log in and user' do
    visit root_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end
end
