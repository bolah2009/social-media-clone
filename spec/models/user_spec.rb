# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a name, email, and password' do
    expect(FactoryBot.build(:user)).to be_valid
  end
  it 'is invalid without a name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end
  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, email: 'test@example.com')
    user = FactoryBot.build(:user, email: 'test@example.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end
end
