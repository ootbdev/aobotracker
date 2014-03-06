Given(/^I have (\d+) (user|employee|manager|administrator)s?$/) do |count, user_type|
  if user_type == 'user'
    User.destroy_all
    # The default for :user factory is to set user type to employee
    # so, for now, this is the same as "Given I have X employees"
    count.to_i.times { FactoryGirl.create(:user) }
  else
    User.where(:u_type => user_type).destroy_all
    count.to_i.times { FactoryGirl.create(:user, user_type.to_sym) }
  end
end

Given(/^I have (?:a|one|1) (expense|task) type called "([^"]+)"?$/) do |model, name|
  case model
  when 'expense'
    factory = :expense_type
  when 'task'
    fatory = :task_type
  end
  FactoryGirl.create(factory, :name => name)
end

Given(/^I have (\d+) tasks?$/) do |count|
  # Since this doesn't specify which user these tasks will belong to,
  # we will just trust the factory to take care of this for us.
  Task.destroy_all
  count.to_i.times { FactoryGirl.create(:task) }
end

Given(/^(user|employee|manager|administrator) (\d+) has (\d+) tasks?$/) do |user_type, user_index, count|
  user = get_user(user_type, user_index)
  user.tasks.destroy_all
  count.to_i.times { FactoryGirl.create(:task, :user_id => user.id) }
end

Given(/^(user|employee|manager|administrator) (\d+) has a task that starts at "([^"]+)" and ends at "([^"]+)"?$/) do |user_type, user_index, start_time, end_time|
  user = get_user(user_type, user_index)
  FactoryGirl.create(:task, :user_id => user.id,
                            :start_time => start_time,
                            :end_time => end_time)
end

When(/^(user|employee|manager|administrator) (\d+) creates a task$/) do |user_type, user_index|
  user = get_user(user_type, user_index)
  FactoryGirl.create(:task, :user_id => user.id) 
end

Given(/^(user|employee|manager|administrator) (\d+) has a task with description "([^"]+)"$/) do |user_type, user_index, description|
  user = get_user(user_type, user_index)
  FactoryGirl.create(:task, :user_id => user.id,
                            :description => description) 
end

When(/^(user|employee|manager|administrator) (\d+) tries to create a task with description "([^"]+)"$/) do |user_type, user_index, description|
  user = get_user(user_type, user_index)
  try_create_task(:user_id => user.id,
                  :description => description)
end

When(/^(user|employee|manager|administrator) (\d+) tries to create a task that starts at "([^"]+)" and ends at "([^"]+)"$/) do |user_type, user_index, start_time, end_time|
  user = get_user(user_type, user_index)
  try_create_task(:user_id => user.id,
                  :start_time => start_time,
                  :end_time => end_time)
end

When(/^I try to create a task that doesn't belong to any user$/) do
  # The :task factory tries to be helpful by creating a user if one
  # doesn't exist.  We want to explicitly try to create a task with
  # no user, so we won't use the factory this time around.
  TaskType.first.should_not be_nil
  begin
    Task.create(:description => Faker::Lorem.sentence,
                :task_type_id => TaskType.first.id,
                :start_time => DateTime.now,
                :end_time => DateTime.now + 10.minutes,
                :user_id => nil)
    rescue ActiveRecord::RecordInvalid
    # Since we want to "try" to create a task, we'll just
    # catch the raised error and move on, doing nothing.
  end
end

When(/^(user|employee|manager|administrator) (\d+) tries to create a task with no (.*)$/) do |user_type, user_index, field|
  user = get_user(user_type, user_index)

  # The :task factory tries to be helpful by creating a task type if one
  # doesn't exist.  We want to explicitly try to create a task with
  # no task type, so we won't use the factory this time around.

  # Since the :task factory tries to be helpful by creating a task type if one
  # doesn't exist, we won't use the factory in the case of no task type.
  if field == 'task type'
    begin
      Task.create(:description => Faker::Lorem.sentence,
                  :user_id => user.id,
                  :start_time => DateTime.now,
                  :end_time => DateTime.now + 10.minutes,
                  :task_type_id => nil)
    rescue ActiveRecord::RecordInvalid
    # Since we want to "try" to create a task, we'll just
    # catch the raised error and move on, doing nothing.
    end
  else
    task = FactoryGirl.build(:task, :user_id => user.id)
    case field
    when 'description'
      task.description = nil
    when 'start date/time'
      task.start_time = nil
    when 'end date/time'
      task.end_time = nil
    end
    begin
      task.save
      rescue ActiveRecord::RecordInvalid
      # Since we want to "try" to create a task, we'll just
      # catch the raised error and move on, doing nothing.
    end
  end
end

When(/^administrator (\d+) tries to create a task$/) do |admin_index|
  user = get_user('administrator', admin_index)
  try_create_task(:user_id => user.id)
end

Then(/^I should(?: still)?(?: only)? have (\d+) tasks?$/) do |count|
  Task.count.should == count.to_i
end

Then(/^I should have (\d+) (user|employee|manager|administrator)s?$/) do |count, user_type|
  if user_type == 'user'
    User.count.should == count.to_i
  else
    User.where(:u_type => user_type).count.should == count.to_i
  end
end

Then(/^task (\d+) should belong to (user|employee|manager|administrator) (\d+)$/) do |task_index, user_type, user_index|
  user = get_user(user_type, user_index)
  Task.all[task_index.to_i - 1].user_id.should == user.id
end

Then(/^(user|employee|manager|administrator) (\d+) should have (\d+) tasks?$/) do |user_type, user_index, count|
  user = get_user(user_type, user_index)
  user.tasks.count.should == count.to_i
end

def get_user(user_type, user_index)
  # user_index can be an integer or an integer as a string
  user_index = Integer(user_index) rescue nil
  user_index.should_not be_nil

  # Assume that user_index is 1-indexed, since Cucumber feature steps are
  # supposed to use normal, everyday language.
  # Example: "user 1" means User.all[0]
  # Example: "employee 4" means User.where(:u_type => 'employee')[3]

  if user_type == 'user'
    user = User.all[user_index - 1]
  else
    user = User.where(:u_type => user_type)[user_index - 1]
  end
  user.should_not be_nil
  return user
end

def get_task(task_index)
  # task_index can be an integer or an integer as a string
  task_index = Integer(task_index) rescue nil
  task_index.should_not be_nil

  # Assume that task_index is 1-indexed, since Cucumber feature steps are
  # supposed to use normal, everyday language.
  # Example: "task 6" means Task.all[5]
  task = Task.all[task_index - 1]
  task.should_not be_nil
  return task
end

def try_create_task(factory_params)
  # Example of factory_params: { :user_id => 5, :description => 'did some work' }
  # Example of factory_params: { :user_id => 2, :task_type_id => 3 }
  #
  # factory_params can be nil, as long as the :task factory definition is set
  # up to deal with missing dependencies (User, TaskType).

  begin
    FactoryGirl.create(:task, factory_params)
    rescue ActiveRecord::RecordInvalid
    # Since we want to "try" to create a task, we'll just
    # catch the raised error and move on, doing nothing.
  end
end
