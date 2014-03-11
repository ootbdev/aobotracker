FactoryGirl.define do
  factory :task do
    task_type_id do
      # If not specified by caller of this factory,
      # then set to the id of the first TaskType,
      # if one exists.  If one does not exist, then
      # create a TaskType
      TaskType.first ? TaskType.first.id : FactoryGirl.create(:task_type).id
    end
    user_id do

      # If not specified by caller of this factory,
      # then set to the id of the first non-administrator User,
      # if one exists.  If one does not exist, then
      # create an employee User.
      non_admins = User.where.not(:u_type => 'administrator')
      non_admins.first ? non_admins.first.id : FactoryGirl.create(:user, :employee).id
    end
    description            { Faker::Lorem.sentence }
    sequence(:start_time)  { |n| Time.now + n.seconds }
    end_time               { start_time + 1.second }
    after(:create) do |task|
      task.user.tasks.append(task)
    end
  end
end
