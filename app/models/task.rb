class Task < ActiveRecord::Base
  has_one :task_type
  belongs_to :user
  
  validate :end_time_greater_than_start_time
  validate :user_is_not_administrator
  validate :task_does_not_overlap_in_time

  def end_time_greater_than_start_time
    if end_time <= start_time
      errors['task'] = "end time must be greater than start time"
    end
  end

  def user_is_not_administrator
    admin = User.find_by_u_type("administrator")
    if admin != nil && admin.id == self.user_id
      errors['task'] = "cannot be assigned to an adminstrator"
    end
  end

  def task_does_not_overlap_in_time
    self.user.tasks.each {|task|
      if ((self.start_time <= task.start_time && self.end_time > task.start_time) || (self.start_time >= task.start_time && self.start_time < task.end_time))
         errors['task'] = "cannot overlap with time of previous tasks"
      end
    }
  end
end
