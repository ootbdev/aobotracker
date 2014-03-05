class User < ActiveRecord::Base
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :u_type, :presence => true, 
  	    	     :inclusion => { :in => ['employee','manager','administrator'] }

  validates :password, :presence => true, 
  	    	       :length => {minimum: 6, maximum: 256}, 
		       :format => { with: /.*[^a-zA-Z].*/, message: "must have at least one non alphabet character"}
  validates :password_confirmation, :presence => true

  validate :only_one_administrator

#  validate :administrator_has_no_tasks


  def only_one_administrator
  u = User.find_by_u_type('administrator')
  if u_type == 'administrator' && u && u.email != email
       errors['user type'] = "cannot be administrator if one already exists"
    end
  end


end


