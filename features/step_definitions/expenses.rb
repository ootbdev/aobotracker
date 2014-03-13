Given(/^I have (#{NUMBER}) expenses?$/) do |count|
  Expense.destroy_all
  count.times { FactoryGirl.create(:expense) }
end

Given(/^(#{USER}) has (#{NUMBER}) expenses?$/) do |user, count|
  user.expenses.destroy_all
  count.times { FactoryGirl.create(:expense, :user_id => user.id) }
end

Given(/^(#{USER}) has created an expense with (#{EXPENSE_TYPE})$/) do |user, et|
  FactoryGirl.create(:expense, :user_id => user.id,
                               :expense_type_id => et.id)
end

Given(/^(#{EXPENSE}) has( not)? been reimbursed$/) do |expense, has_not|
  if has_not
    expense.status.should == 'not reimbursed'
  else
    expense.status.should == 'reimbursed'
  end
end

Then(/^(#{USER}) should( not)? be able to set (#{EXPENSE}) as( not)? reimbursed$/) do |user, should_not, expense, not_reimbursed|
  status = not_reimbursed ? 'not reimbursed' : 'reimbursed'
  if should_not
    user.set_expense_status(expense, status).should_not be_true
  else
    user.set_expense_status(expense, status).should be_true
  end
end

Then(/^I should( not)? be able to create an expense with status "([^"]+)"$/) do |should_not, value|
  e = FactoryGirl.build(:expense, :status => value)
  if should_not
    e.valid?.should be_false
  else
    e.valid?.should be_true
  end
end

When(/^(#{USER}) creates an expense$/) do |user|
  FactoryGirl.create(:expense, :user_id => user.id) 
end

When(/^(#{USER}) tries to create an expense$/) do |user|
  try_create_expense(:user_id => user.id)
end

When(/^I try to create an expense that doesn't belong to any user$/) do
  # The :expense factory tries to be helpful by creating a user if one
  # doesn't exist.  We want to explicitly try to create a expense with
  # no user, so we won't use the factory this time around.
  ExpenseType.first.should_not be_nil
  e = Expense.new(:description => Faker::Lorem.sentence,
                  :expense_type_id => ExpenseType.first.id,
                  :date => Date.today,
                  :amount => Faker::Number.number(2),
                  :currency => 'USD',
                  :status => Aobotracker::Application.config.expense_statuses[0],
                  :user_id => nil)
  e.save if e.valid?
end

When(/^(#{USER}) tries to create an expense with no (.*)$/) do |user, field|
  # Since the :expense factory tries to be helpful by creating a expense type if one
  # doesn't exist, we won't use the factory in the case of no expense type.
  if field == 'ExpenseType'
    e = Expense.new(:description => Faker::Lorem.sentence,
                    :user_id => user.id,
                    :date => Date.today,
                    :amount => Faker::Number.number(2),
                    :currency => 'USD',
                    :status => Aobotracker::Application.config.expense_statuses[0],
                    :expense_type_id => nil)
  else
    e = FactoryGirl.build(:expense, :user_id => user.id)
    case field
    when 'description'
      e.description = nil
    when 'date'
      e.date = nil
    when 'amount'
      e.amount = nil
    when 'currency'
      e.currency = nil
    end
  end
  e.save if e.valid?
end

When(/^(#{USER}) tries to create an expense that is identical to (#{EXPENSE})$/) do |user, expense|
  try_create_expense(:user_id => user.id,
                     :expense_type_id => expense.expense_type_id,
                     :description => expense.description,
                     :date => expense.date,
                     :amount => expense.amount,
                     :currency => expense.currency)
end

When(/^(#{USER}) tries to create an expense with currency (.*)$/) do |user, currency|
  try_create_expense(:user_id => user.id,
                     :currency => currency)
end

When(/^(#{USER}) sets the (.*) of (#{EXPENSE}) to "([^"]+)"$/) do |user, field, expense, value|
  case field
  when 'expense type'
    params = { :expense_type_id => ExpenseType.find_by_name(value).id }
  else
    params = { field => value }
  end
  user.modify_expense(expense, params) 
end

Then(/^the (.*) of (#{EXPENSE}) should( not)? be "([^"]+)"$/) do |field, expense, should_not, value|
  # Default
  left_side = expense[field]
  right_side = value

  case field
  when 'expense type'
    left_side = expense.expense_type
    right_side = ExpenseType.find_by_name(value)
  when 'amount'
    left_side = "%.2f" % expense[field]
  when 'date'
    right_side = value.to_date
  end

  if should_not
    left_side.should_not == right_side
  else
    left_side.should == right_side
  end
end

Then(/^(#{USER}) should have (#{NUMBER}) expenses?$/) do |user, count|
  user.expenses.count.should == count
end

Then(/^(#{EXPENSE}) should belong to (#{USER})$/) do |expense, user|
  expense.user_id.should == user.id
end

Then(/^I should(?: still)?(?: only)? have (#{NUMBER}) expenses?$/) do |count|
  Expense.count.should == count
end

def try_create_expense(factory_params)
  # Example of factory_params: { :user_id => 5, :description => 'did some work' }
  # Example of factory_params: { :user_id => 2, :expense_type_id => 3 }
  #
  # factory_params can be nil, as long as the :expense factory definition is set
  # up to deal with missing dependencies (User, ExpenseType).
  e = FactoryGirl.build(:expense, factory_params)
  e.save if e.valid?
end
