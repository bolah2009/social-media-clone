# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    content { 'A new testing post.' }
    association :user
  end
end
