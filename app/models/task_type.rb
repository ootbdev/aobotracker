class TaskType < ActiveRecord::Base
  validates :name, :uniqueness => true,
                   :presence => true,
                   :length => { :maximum => 30 }

  before_validation do |tasktype|
    tasktype.name.strip!
  end
end
