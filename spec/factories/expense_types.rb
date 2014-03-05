# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense_type do
    name { Faker::Lorem.characters(1..30) }
  end
end
