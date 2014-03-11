class TaskType < ActiveRecord::Base
  has_many :tasks

  validates :name, :uniqueness => true,
                   :presence => true,
                   :length => { :maximum => 30 }

  before_validation do |tasktype|
    tasktype.name.strip!
  end

  before_destroy do
    if self.tasks.count != 0
      errors['task type'] = "cannot be deleted if associated tasks exist"
      false
    end
  end
end
