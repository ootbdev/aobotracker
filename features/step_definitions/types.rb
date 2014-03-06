Given(/^I have (\d+) (expense|task) type$/) do |count, model|
  case model
  when 'expense'
    ExpenseType.destroy_all
    count.to_i.times { FactoryGirl.create(:expense_type) }
  when 'task'
    TaskType.destroy_all
    count.to_i.times { FactoryGirl.create(:task_type) }
  end
end

Then(/^I should have (\d+) (expense|task) type$/) do |count, model|
  case model
  when 'expense'
    ExpenseType.count.should == count.to_i
  when 'task'
    TaskType.count.should == count.to_i
  end
end

When(/^I add (?:a|one|1|the) (expense|task) type called: "(.*)"$/) do |model, name|
  if model == 'expense'
    factory = :expense_type
  elsif model == 'task'
    factory = :task_type
  end

  begin
    FactoryGirl.create(factory, :name => name)
    rescue ActiveRecord::RecordInvalid
    # DO NOTHING. ALLOW THE ERROR TO BE RAISED.
  end
end

Then(/^I should not be able to add a (expense|task) type called: "(.*)"$/) do |model, name|
  if model == 'expense'
    factory = :expense_type
  elsif model == 'task'
    factory = :task_type
  end
  record = FactoryGirl.build(factory, :name => name)
  record.valid?.should be_false
end
