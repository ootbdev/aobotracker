FactoryGirl.define do
  factory :expense do
    expense_type_id do
      # If not specified by caller of this factory,
      # then set to the id of the first expenseType,
      # if one exists.  If one does not exist, then
      # create a expenseType
      ExpenseType.first ? ExpenseType.first.id : FactoryGirl.create(:expense_type).id
    end
    user_id do
      # If not specified by caller of this factory,
      # then set to the id of the first non-administrator User,
      # if one exists.  If one does not exist, then
      # create an employee User.
      non_admins = User.where.not(:u_type => 'administrator')
      non_admins.first ? non_admins.first.id : FactoryGirl.create(:user, :employee).id
    end
    description          { Faker::Lorem.sentence   }
    sequence(:date)      { |n| Date.today + n.days }
    amount               { Faker::Number.number(2) }
    currency             "CNY"
    is_reimbursed        false
  end
end
