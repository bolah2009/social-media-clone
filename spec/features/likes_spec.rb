require 'rails_helper'

RSpec.feature 'Likes', type: :feature do

  let(:user) { FactoryBot.create(:user, :with_posts) }
  let(:other_user) { FactoryBot.create(:user) }

  before do
    visit root_path
    fill_in 'user_email',    with: other_user.email
    fill_in 'user_password', with: other_user.password
    click_button 'Log in'
  end

  scenario "user can like other user posts" do
    expect do
      find("name='like-button'").click
    end.to change(other_user.likes_given, :count).by(1)
  end
end
