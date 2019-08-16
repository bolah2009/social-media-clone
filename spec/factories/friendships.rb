# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    user_id { 1 }
    friend_id { 1 }
  end
end
