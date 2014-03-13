Given(/^I have (#{NUMBER}) ([^ ]+ypes?)$/) do |count, class_name|
  Object.const_get(class_name.singularize).destroy_all
  count.times { FactoryGirl.create(class_name_to_sym(class_name)) }
end

Given(/^I have (?:an?|one|1|the) (task|expense) type "([^"]+)"$/) do |class_name, name|
  if class_name == 'task'
    FactoryGirl.create(:task_type, :name => name)
  elsif class_name == 'expense'
    FactoryGirl.create(:expense_type, :name => name)
  end
end

Then(/^I should have (#{NUMBER}) ([^ ]+ypes?)$/) do |count, class_name|
  Object.const_get(class_name.singularize).count.should == count
end

When(/^I add (?:a|one|1|the) ([^ ]+) called: "(.*)"$/) do |class_name, name|
  begin
    FactoryGirl.create(class_name_to_sym(class_name), :name => name)
    rescue ActiveRecord::RecordInvalid
    # DO NOTHING. ALLOW THE ERROR TO BE RAISED.
  end
end

Then(/^I should not be able to add an? ([^ ]+) called: "(.*)"$/) do |class_name, name|
  class_name = class_name.gsub(/([A-Z])/, '_\1')
  class_name.downcase!
  class_name.slice!(0)
  puts "Attempting to build instance of #{class_name}"
  record = FactoryGirl.build(class_name_to_sym(class_name), :name => name)
  record.valid?.should be_false
end

Then(/^(#{USER}) should( not)? be able to delete (#{EXPENSE_TYPE})$/) do |user, should_not, et|
  if should_not
    user.delete_expense_type(et).should be_false
    ExpenseType.find_by_id(et.id).should_not be_nil
  else
    user.delete_expense_type(et).should be_true
    ExpenseType.find_by_id(et.id).should be_nil
  end
end

def class_name_to_sym(class_name)
  # Expects "TaskType", converts and returns :task_type
  class_name.gsub(/([A-Z])/, '_\1').gsub(/^_/,'').downcase
end
