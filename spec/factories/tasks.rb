# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    task_type nil
    description "MyString"
    start_time "2014-03-06 11:02:12"
    end_time "2014-03-06 11:02:12"
    user nil
  end
end
