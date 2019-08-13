require 'rails_helper'

RSpec.describe Like, type: :model do

  let(:like) do
    FactoryBot.build(:like, user: nil, post: nil)
  end

  it "is invalid without a user" do
    like.valid?
    expect(like.errors[:user]).to include("must exist")
  end

  it "is invalid without a post" do
    like.valid?
    expect(like.errors[:post]).to include("must exist")
  end
end
