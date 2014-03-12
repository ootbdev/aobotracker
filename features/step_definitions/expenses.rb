Given(/^I have (#{NUMBER}) expenses?$/) do |count|
  Expense.destroy_all
  count.times { FactoryGirl.create(:expense) }
end

Given(/^(#{USER}) has (#{NUMBER}) expenses?$/) do |user, count|
  user.expenses.destroy_all
  count.times { FactoryGirl.create(:expense, :user_id => user.id) }
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
  begin
    Expense.create(:description => Faker::Lorem.sentence,
                   :expense_type_id => ExpenseType.first.id,
                   :date => Date.today,
                   :amount => Faker::Number.number(2),
                   :currency => 'USD',
                   :is_reimbursed => false,
                   :user_id => nil)
    rescue ActiveRecord::RecordInvalid
    # Since we want to "try" to create a task, we'll just
    # catch the raised error and move on, doing nothing.
  end
end

When(/^(#{USER}) tries to create an expense with no (.*)$/) do |user, field|
  # Since the :expense factory tries to be helpful by creating a expense type if one
  # doesn't exist, we won't use the factory in the case of no expense type.
  if field == 'expense type'
    begin
      Expense.create(:description => Faker::Lorem.sentence,
                     :user_id => user.id,
                     :date => Date.today,
                     :amount => Faker::Number.number(2),
                     :currency => 'USD',
                     :is_reimbursed => false,
                     :expense_type_id => nil)
    rescue ActiveRecord::RecordInvalid
    # Since we want to "try" to create a expense, we'll just
    # catch the raised error and move on, doing nothing.
    end
  else
    expense = FactoryGirl.build(:expense, :user_id => user.id)
    case field
    when 'description'
      expense.description = nil
    when 'date'
      expense.date = nil
    when 'amount'
      expense.amount = nil
    when 'currency'
      expense.currency = nil
    end
    begin
      expense.save
      rescue ActiveRecord::RecordInvalid
      # Since we want to "try" to create a expense, we'll just
      # catch the raised error and move on, doing nothing.
    end
  end
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

  begin
    FactoryGirl.create(:expense, factory_params)
    rescue ActiveRecord::RecordInvalid
    # Since we want to "try" to create a expense, we'll just
    # catch the raised error and move on, doing nothing.
  end
end
