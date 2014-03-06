class User < ActiveRecord::Base
  has_many :tasks

  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :email, :presence => true,
                    :uniqueness => true
  validates :u_type, :presence => true,
                     :inclusion => { :in => ['employee','manager','administrator'] }

  validate :only_one_administrator

#  validate :administrator_has_no_tasks


  def only_one_administrator
  u = User.find_by_u_type('administrator')
  if u_type == 'administrator' && u && u.email != email
       errors['user type'] = "cannot be administrator if one already exists"
    end
  end


end


