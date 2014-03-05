# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    p = Faker::Internet.password.concat(Faker::Number.digit.to_s)
    firstname { Faker::Name.first_name }
    lastname  { Faker::Name.last_name }
    email     { Faker::Internet.email }

    trait :employee do
      u_type 'employee'
    end

    trait :manager do
      u_type 'manager'
    end

    trait :administrator do
      u_type 'administrator'
    end

    password p
    password_confirmation p
  end
end
