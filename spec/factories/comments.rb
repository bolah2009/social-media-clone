# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'My comment' }
    association :post
    association :user
  end
end
