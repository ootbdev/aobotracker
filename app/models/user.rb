class User < ActiveRecord::Base
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :email, :presence => true,
                    :uniqueness => true
  validates :u_type, :presence => true,
                     :inclusion => { :in => ['employee','manager','administrator'] }

  validate :only_one_administrator

  def only_one_administrator
    if u_type == 'administrator' && User.find_by_u_type('administrator')
       errors['user type'] = "cannot be administrator if one already exists"
    end
  end
end
