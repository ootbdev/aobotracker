Given(/^I have 0 tasks and a user with email address "(.*?)" and a task type "(.*?)"$/) do |email, task_type|
  Task.count.should == 0
  FactoryGirl.create(:user, email: email)
  FactoryGirl.create(:task_type, name: task_type)
end

 Then(/^I should( not)? be able to create 1 task with task type "(.*?)", description "(.*?)", start time "(.*?)", end time "(.*?)" assigned to "(.*?)"$/) do |should_not, task_type, description, start_time, end_time, user_email|

  u = User.find_by_email(user_email)
  
  ttype = TaskType.find_by_name(task_type)
  
  if should_not 
    u.tasks.create(task_type_id: ttype.id, description: description, start_time: Time.parse(start_time), end_time: Time.parse(end_time)).valid?.should be_false
  else
    u.tasks.create(task_type_id: ttype.id, description: description, start_time: Time.parse(start_time), end_time: Time.parse(end_time)).valid?.should be_true
  end
end


Given(/^I have 0 tasks and an administrator user with email address "(.*?)"$/) do |user_email|
  Task.count.should == 0
  FactoryGirl.create(:user, u_type: "administrator", email: user_email)
  FactoryGirl.create(:task_type)
end

Then(/^I should not be able to create a task with the user "(.*?)"$/) do |user_email|
  u = User.find_by_email(user_email)
  ttype = TaskType.first
  u.tasks.create(task_type_id: ttype.id, description: "hurrah", start_time: Time.now, end_time: Time.now).valid?.should be_false
end

Then(/^I should be able to create 2 tasks with identical task types "(.*?)" and descriptions "(.*?)"$/) do |task_type, description|
  ttype = FactoryGirl.create(:task_type, name: task_type)
  User.first.tasks.create(task_type_id: ttype.id, description: description, start_time: Time.now, end_time: Time.now)
  User.first.tasks.create(task_type_id: ttype.id, description: description, start_time: Time.now, end_time: Time.now).valid?.should be_true
  User.first.tasks.count.should == 2
end

Given(/^I have a user with a task where the task type is "(.*?)", the description is "(.*?)", the start time is "(.*?)" and the end time is "(.*?)"$/) do |task_type, description, start_time, end_time|
  u = FactoryGirl.create(:user)
  ttype = FactoryGirl.create(:task_type, name: task_type)
  u.tasks.create(task_type_id: ttype.id, description: description, start_time: start_time, end_time: end_time)
end

Then(/^I should( not)? be able to create a task with start time "(.*?)" and end time "(.*?)"$/) do |should_not, start_time, end_time|
  ttype = FactoryGirl.create(:task_type)

  if should_not
    User.first.tasks.create(task_type_id: ttype.id, description: "Doesn't matter", start_time: start_time, end_time: end_time).valid?.should be_false
  else
    User.first.tasks.create(task_type_id: ttype.id, description: "Doesn't matter", start_time: start_time, end_time: end_time).valid?.should be_true   
  end
end



Given(/^I have a user$/) do
  FactoryGirl.create(:user, u_type: "employee")
end

Then(/^I should not be able to create a task with end time less or equal to start time$/) do
  ttype = FactoryGirl.create(:task_type)
  t = Time.now
  User.first.tasks.create(task_type_id: ttype.id, description: "Something beautiful", start_time: t, end_time: t-10).valid?.should be_false
  t = t + 100
  User.first.tasks.create(task_type_id: ttype.id, description: "Something beautiful", start_time: t, end_time: t).valid?.should be_false
end


