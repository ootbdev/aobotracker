class User < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  has_many :expenses, dependent: :destroy

  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :email, :presence => true,
                    :uniqueness => true
  validates :u_type, :presence => true,
                     :inclusion => { :in => ['employee','manager','administrator'] }

  validate :only_one_administrator

  def delete_expense_type(et)
    (has_privilege?(:delete_expense_type) && 
     et.expenses.count == 0) ? et.destroy : false
  end

  def set_expense_status(expense, status)
    has_privilege?(:set_expense_status) ? expense.update(:status => status) : false
  end

  def modify_expense(expense, params)
    (has_privilege?(:modify_expense) ||
     self == expense.user) ? expense.update(params) : false
  end

  def only_one_administrator
  u = User.find_by_u_type('administrator')
  if u_type == 'administrator' && u && u.email != email
       errors['user type'] = "cannot be administrator if one already exists"
    end
  end

  private

  def has_privilege?(privilege)
    Rails.application.config.privileges[privilege].include?(u_type)
  end
end


