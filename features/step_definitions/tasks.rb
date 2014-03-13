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
  t = Task.new(:description => Faker::Lorem.sentence,
               :task_type_id => TaskType.first.id,
               :start_time => DateTime.now,
               :end_time => DateTime.now + 10.minutes,
               :user_id => nil)
  t.save if t.valid?
end

When(/^(#{USER}) tries to create a task with no (.*)$/) do |user, field|
  # The :task factory tries to be helpful by creating a task type if one
  # doesn't exist.  We want to explicitly try to create a task with
  # no task type, so we won't use the factory this time around.

  # Since the :task factory tries to be helpful by creating a task type if one
  # doesn't exist, we won't use the factory in the case of no task type.
  if field == 'task type'
    t = Task.new(:description => Faker::Lorem.sentence,
                 :user_id => user.id,
                 :start_time => DateTime.now,
                 :end_time => DateTime.now + 10.minutes,
                 :task_type_id => nil)
  else
    t = FactoryGirl.build(:task, :user_id => user.id)
    case field
    when 'description'
      t.description = nil
    when 'start date/time'
      t.start_time = nil
    when 'end date/time'
      t.end_time = nil
    end
  end
  t.save if t.valid?
end

When(/^(#{USER}) tries to create a task$/) do |user|
  try_create_task(:user_id => user.id)
end

Then(/^I should(?: still)?(?: only)? have (#{NUMBER}) tasks?$/) do |count|
  Task.count.should == count
end

Then(/^(#{TASK}) should belong to (#{USER})$/) do |task, user|
  task.user_id.should == user.id
end

Then(/^(#{USER}) should have (#{NUMBER}) tasks?$/) do |user, count|
  user.tasks.count.should == count
end

Then(/^I should not be able to set the task type to nil$/) do
  t = Task.first
  t.task_type = nil
  t.valid?.should be_false
end

When(/^I try to destroy the task type$/) do
  t = Task.first
  t.task_type.destroy
end

Then(/^that task type should still exist$/) do
  TaskType.first.should_not be_nil
end

def try_create_task(factory_params)
  # Example of factory_params: { :user_id => 5, :description => 'did some work' }
  # Example of factory_params: { :user_id => 2, :task_type_id => 3 }
  #
  # factory_params can be nil, as long as the :task factory definition is set
  # up to deal with missing dependencies (User, TaskType).
  t = FactoryGirl.build(:task, factory_params)
  t.save if t.valid?
end
