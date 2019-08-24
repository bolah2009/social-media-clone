# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) do
    FactoryBot.build(:like, user: nil, post: nil)
  end

  let(:valid_like) { FactoryBot.create(:like) }

  it 'is valid with a user and post' do
    valid_like.valid?
    expect(valid_like.errors).to be_empty
  end

  it 'is invalid without a user' do
    like.valid?
    expect(like.errors[:user]).to include('must exist')
  end

  it 'is invalid without a post' do
    like.valid?
    expect(like.errors[:post]).to include('must exist')
  end
end
