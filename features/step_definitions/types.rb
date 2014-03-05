Given(/^I (?:should )?have (\d+) ([^ ]+)$/) do |count, class_name|
  Object.const_get(class_name.singularize).count.should == count.to_i
end

When(/^I add (?:a|one|1|the) ([^ ]+) called: "(.*)"$/) do |class_name, name|
  begin
    FactoryGirl.create(class_name_to_sym(class_name), :name => name)
    rescue ActiveRecord::RecordInvalid
    # DO NOTHING. ALLOW THE ERROR TO BE RAISED.
  end
end

Then(/^I should not be able to add a ([^ ]+) called: "(.*)"$/) do |class_name, name|
  class_name = class_name.gsub(/([A-Z])/, '_\1')
  class_name.downcase!
  class_name.slice!(0)
  puts "Attempting to build instance of #{class_name}"
  record = FactoryGirl.build(class_name_to_sym(class_name), :name => name)
  record.valid?.should be_false
end

def class_name_to_sym(class_name)
  # Expects "TaskType", converts and returns :task_type
  class_name.gsub(/([A-Z])/, '_\1').gsub(/^_/,'').downcase
end
