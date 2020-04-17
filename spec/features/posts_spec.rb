# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  it 'user sign in and creates a valid post' do
    sign_in user

    visit root_path

    expect do
      fill_in :post_content, with: 'Hi there!'
      click_button 'Post'
      expect(page).to have_content 'Post was successfully created'
      expect(page).to have_content 'Hi there!'
    end.to change(user.posts, :count).by(1)

    expect do
      fill_in :post_content, with: ''
      click_button 'Post'
      expect(page).to have_css '#error_explanation'
      expect(page).to have_content "Content can't be blank"
    end.to change(user.posts, :count).by(0)
  end
end
