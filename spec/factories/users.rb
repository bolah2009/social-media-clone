# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:friend] do
    name { 'Bola' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }

    trait :with_posts do
      after(:create) { |user| create_list(:post, 5, user: user) }
    end
  end
end
