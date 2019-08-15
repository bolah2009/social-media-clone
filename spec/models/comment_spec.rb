# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) do
    FactoryBot.build(:comment, user: nil, post: nil, content: '')
  end

  let(:valid_comment) { FactoryBot.create(:comment) }

  it 'is valid with a user, post and content' do
    valid_comment.valid?
    expect(valid_comment.errors).to be_empty
  end

  it 'is invalid without a user' do
    comment.valid?
    expect(comment.errors[:user]).to include('must exist')
  end

  it 'is invalid without a post' do
    comment.valid?
    expect(comment.errors[:post]).to include('must exist')
  end

  it 'is invalid without a content' do
    comment.valid?
    expect(comment.errors[:content]).to include("can't be blank")
  end
end
