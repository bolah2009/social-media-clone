# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Posts', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  scenario 'user sign in and creates a new post' do
    sign_in user

    visit root_path

    expect do
      fill_in :post_content, with: 'Hi there!'
      click_button 'Post'
      expect(page).to have_content 'Post was successfully created'
      expect(page).to have_content 'Hi there!'
    end.to change(user.posts, :count).by(1)
  end
end
