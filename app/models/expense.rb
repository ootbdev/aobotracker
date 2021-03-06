class Expense < ActiveRecord::Base
  belongs_to :user
  belongs_to :expense_type

  validates :user_id, :presence => true
  validates :expense_type_id, :presence => true
  validates :description, :presence => true
  validates :date, :presence => true
  validates :amount, :presence => true
  validates :status, :presence => true,
                     :inclusion => { :in => Aobotracker::Application.config.expense_statuses }

  validates :currency, :presence => true,
                       :inclusion => { :in => Aobotracker::Application.config.expense_currencies }

  validate :user_is_not_administrator

  def user_is_not_administrator
   if user_id && user.u_type == 'administrator'
      errors['expense'] = "cannot be assigned to an adminstrator"
   end
  end
end
