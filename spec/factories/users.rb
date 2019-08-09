# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Bola' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
