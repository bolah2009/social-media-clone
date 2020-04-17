# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  let(:params) { FactoryBot.attributes_for(:user) }
  let!(:dup_user) { FactoryBot.create(:user) }

  let(:user) { FactoryBot.create(:user) }

  it 'create a new user with valid entries' do
    visit root_path

    fill_in 'new_user_name', with: params[:name]
    fill_in 'new_user_email', with: params[:email]
    fill_in 'new_user_password', with: params[:password]
    fill_in 'new_user_password_confirmation', with: params[:password]

    expect do
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end.to change(User.all, :count).by(1)
  end

  it 'create a new user with invalid entries' do
    visit root_path

    fill_in 'new_user_name', with: ''
    fill_in 'new_user_email', with: dup_user[:email]
    fill_in 'new_user_password', with: 'bad'
    fill_in 'new_user_password_confirmation', with: ''

    expect do
      click_button 'Sign up'
      expect(page).to have_css '#error_explanation'
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content 'Email has already been taken'
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end.to change(User.all, :count).by(0)
  end

  it 'log in a valid user' do
    visit root_path
    within('.nav-content') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password

      click_button 'Log in'
    end
    expect(page).to have_content 'Signed in successfully.'
  end

  it 'log in with invalid user' do
    visit root_path
    within('.nav-content') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'invalid password'

      click_button 'Log in'
    end

    expect(page).to have_content 'Invalid Email or password.'
  end
end
