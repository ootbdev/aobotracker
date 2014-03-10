NUMBER = Transform /^(a|one|the|no|zero|\d+)$/ do |value|
  number = Integer(value) rescue nil
  unless number
    if value == 'a' || value == 'one' || value == 'the'
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

TASK = Transform /^task (\d+)$/ do |task_index|
  get_task(task_index)
end

def get_user(user_type, user_index)
  # user_index can be an integer or an integer as a string
  user_index = Integer(user_index) rescue nil
  user_index.should_not be_nil

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

def get_task(task_index)
  # task_index can be an integer or an integer as a string
  task_index = Integer(task_index) rescue nil
  task_index.should_not be_nil

  # Assume that task_index is 1-indexed, since Cucumber feature steps are
  # supposed to use normal, everyday language.
  # Example: "task 6" means Task.all[5]
  task = Task.all[task_index - 1]
  task.should_not be_nil
  return task
end
