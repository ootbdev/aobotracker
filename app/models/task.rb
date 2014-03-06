class Task < ActiveRecord::Base
  has_one :task_type
  belongs_to :user

#  validates :user_id, :presence => true
#  validates :task_type_id, :presence => true
#  validates :description, :presence => true
#  validates :start_time, :presence => true
#  validates :end_time, :presence => true

  validate :end_time_greater_than_start_time
  validate :user_is_not_administrator
  validate :task_does_not_overlap_in_time

  def end_time_greater_than_start_time
#    unless start_time.nil? || end_time.nil?
      if end_time <= start_time
        errors['task'] = "end time must be greater than start time"
      end
#    end
  end

  def user_is_not_administrator
    admin = User.find_by_u_type("administrator")
    if admin != nil && admin.id == self.user_id
      errors['task'] = "cannot be assigned to an adminstrator"
    end
#   The find_by method finds the *first* record that satisfies the criteria.
#   We know that the specs say there should be only one administrator, but
#   in case that spec changes, the find_by method could break.  If there
#   were 2 administrators, and the second administrator is the one attempting
#   to create a task, then the above validation would only ensure that the
#   task-creating user is not the *first* administrator.
#   
#   The where() method is better, as it returns an array of all 
#   records that satisfy the criteria.  Then you can search through the array.
#
#   Or better yet: just ask if this user is an administrator.
#   if user.u_type ==' administrator'
#      errors['task'] = "cannot be assigned to an adminstrator"
#   end
  end

  def task_does_not_overlap_in_time
    if self.user
      self.user.tasks.each do |task|
        if ((self.start_time <= task.start_time && self.end_time > task.start_time) || (self.start_time >= task.start_time && self.start_time < task.end_time))
          errors['task'] = "cannot overlap with time of previous tasks"
        end
      end
    end
  end
end
