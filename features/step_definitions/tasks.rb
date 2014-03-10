Given(/^I have (#{NUMBER}) (user|employee|manager|administrator)s?$/) do |count, user_type|
  if user_type == 'user'
    User.destroy_all
    # The default for :user factory is to set user type to employee
    # so, for now, this is the same as "Given I have X employees"
    count.times { FactoryGirl.create(:user) }
  else
    User.where(:u_type => user_type).destroy_all
    count.times { FactoryGirl.create(:user, user_type.to_sym) }
  end
end

Given(/^I have (?:a|one|1) (expense|task) type called "([^"]+)"?$/) do |model, name|
  case model
  when 'expense'
    factory = :expense_type
  when 'task'
    factory = :task_type
  end
  FactoryGirl.create(factory, :name => name)
end

Given(/^I have (#{NUMBER}) tasks?$/) do |count|
  # Since this doesn't specify which user these tasks will belong to,
  # we will just trust the factory to take care of this for us.
  Task.destroy_all
  count.times { FactoryGirl.create(:task) }
end

Given(/^(#{USER}) has (#{NUMBER}) tasks?$/) do |user, count|
  user.tasks.destroy_all
  count.times { FactoryGirl.create(:task, :user_id => user.id) }
end

Given(/^(#{USER}) has a task that starts at "([^"]+)" and ends at "([^"]+)"?$/) do |user, start_time, end_time|
  FactoryGirl.create(:task, :user_id => user.id,
                            :start_time => start_time,
                            :end_time => end_time)
end

When(/^(#{USER}) creates a task$/) do |user|
  FactoryGirl.create(:task, :user_id => user.id) 
end

Given(/^(#{USER}) has a task with description "([^"]+)"$/) do |user, description|
  FactoryGirl.create(:task, :user_id => user.id,
                            :description => description) 
end

When(/^(#{USER}) tries to create a task with description "([^"]+)"$/) do |user, description|
  try_create_task(:user_id => user.id,
                  :description => description)
end

When(/^(#{USER}) tries to create a task that starts at "([^"]+)" and ends at "([^"]+)"$/) do |user, start_time, end_time|
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

When(/^(#{USER}) tries to create a task with no (.*)$/) do |user, field|
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

When(/^(#{USER}) tries to create a task$/) do |user|
  try_create_task(:user_id => user.id)
end

Then(/^I should(?: still)?(?: only)? have (#{NUMBER}) tasks?$/) do |count|
  Task.count.should == count
end

Then(/^I should have (#{NUMBER}) (user|employee|manager|administrator)s?$/) do |count, user_type|
  if user_type == 'user'
    User.count.should == count
  else
    User.where(:u_type => user_type).count.should == count
  end
end

Then(/^(#{TASK}) should belong to (#{USER})$/) do |task, user|
  task.user_id.should == user.id
end

Then(/^(#{USER}) should have (#{NUMBER}) tasks?$/) do |user, count|
  user.tasks.count.should == count
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
