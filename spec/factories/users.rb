# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname  { Faker::Name.last_name }
    email     { Faker::Internet.email }
    u_type 'employee'

    trait :manager do
      u_type 'manager'
    end

    trait :administrator do
      u_type 'administrator'
    end
  end
end
