NUMBER = Transform /^(an?|one|the|no|zero|\d+)$/ do |value|
  number = Integer(value) rescue nil
  unless number
    if value == 'a' || value == 'an' || value == 'one' || value == 'the'
      number = 1
    elsif value == 'no' || value == 'zero'
      number = 0
    end
  end
  number.should_not be_nil
  number
end

USER = Transform /^(user|employee|manager|administrator) (\d+)$/ do |user_type, user_index|
  get_user(user_type, user_index)
end

TASK = Transform /^task (#{NUMBER})$/ do |task_index|
  get_record(Task, task_index)
end

EXPENSE = Transform /^expense (#{NUMBER})$/ do |expense_index|
  get_record(Expense, expense_index)
end

EXPENSE_TYPE = Transform /^expense type (#{NUMBER})$/ do |et_index|
  get_record(ExpenseType, et_index)
end

TASK_TYPE = Transform /^task type (#{NUMBER})$/ do |tt_index|
  get_record(TaskType, tt_index)
end

def get_user(user_type, user_index)
  user_index = convert_to_int_or_fail(user_index)

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
  user
end

def get_record(class_name, index)
  # Assume that index is 1-indexed, since Cucumber feature steps are
  # supposed to use normal, everyday language.
  # Example: "record 6" means Record.all[5]
  record = class_name.all[convert_to_int_or_fail(index) - 1]
  record.should_not be_nil
  return record
end

def convert_to_int_or_fail(value)
  # value can be an integer or an integer as a string
  # will return the (converted) integer.
  # if it can't convert (e.g. value = 'abc'), then expectation will fail
  value = Integer(value) rescue nil
  value.should_not be_nil
  value
end
