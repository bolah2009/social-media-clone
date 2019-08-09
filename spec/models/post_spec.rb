# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'is invalid without a content' do
    new_post = FactoryBot.build(:post, content: '')
    new_post.valid?
    expect(new_post.errors[:content]).to include("can't be blank")
  end

  it 'is invalid without a user' do
    new_post = FactoryBot.build(:post, user: nil)
    new_post.valid?
    expect(new_post.errors[:user]).to include('must exist')
  end
end
