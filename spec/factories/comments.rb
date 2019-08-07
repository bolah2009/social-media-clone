FactoryBot.define do
  factory :comment do
    user_id { 1 }
    post_id { 1 }
    content { "MyText" }
  end
end
