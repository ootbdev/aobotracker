class ExpenseType < ActiveRecord::Base
  has_many :expenses
  validates :name, :uniqueness => true,
                   :presence => true,
                   :length => { :maximum => 30 }

  before_validation do |expensetype|
    expensetype.name.strip!
  end
end
