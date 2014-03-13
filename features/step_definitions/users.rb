Given(/^I have (#{NUMBER}) (user|employee|manager|administrator)s?$/) do |count, user_type|
  if user_type == 'user'
    User.destroy_all
    # The default for :user factory is to set user type to employee
    # so, for now, this is the same as "Given I have X employees"
    count.times { FactoryGirl.create(:user) }
  else
    User.where(:u_type => user_type).destroy_all
    count.times { FactoryGirl.create(:user, user_type.to_sym) }
  end
end

Given(/^I have one user of type (.*)$/) do |u_type|
  u = FactoryGirl.create(:user, :u_type => u_type)
end

Given(/^I have one user with an email address: ([[:alpha:].]+@[[:alpha:].]+)$/) do |email|
  FactoryGirl.create(:user, :email => email)
end

When(/^I add a user with the first name: ([[:alpha:]]+), the last name: ([[:alpha:]]+), email address: ([[:alpha:].]+@[[:alpha:].]+), and user type: ([[:alpha:]]+)$/) do | first, last, email, type | 
  User.create(:firstname => first, :lastname => last, :email => email, :u_type => type)
end

When(/^I delete (#{USER})$/) do |user|
  user.destroy
end

Then(/^I should have (#{NUMBER}) (user|employee|manager|administrator)s?$/) do |count, user_type|
  if user_type == 'user'
    User.count.should == count
  else
    User.where(:u_type => user_type).count.should == count
  end
end

Then (/^I should have a user with the first name: ([[:alpha:]]+), the last name: ([[:alpha:]]+), email address: ([[:alpha:].]+@[[:alpha:].]+), and user type: ([[:alpha:]]+)$/) do | first, last, email, type | 
  myUser = User.find_by_email(email) 
  myUser.should_not be_nil
  myUser.firstname.should == first
  myUser.lastname.should == last
  myUser.u_type.should == type
end

Then(/^I should not be able to set a blank ([[:alpha:] ]+) for user with email address: ([[:alpha:].]+@[[:alpha:].]+)$/) do |field, email|
  myUser = User.find_by_email(email) 
  myUser.should_not be_nil
  case field
    when "first name"
    myUser.firstname = ''
    when "last name"
    myUser.lastname = ''
    when "email address"
    myUser.email = ''
    when "user type"
    myUser.u_type = ''
  end
  myUser.valid?.should be_false
end

Then(/^I should not be able to add a user with an email address: ([[:alpha:].]+@[[:alpha:].]+)$/) do |email|
  u = FactoryGirl.build(:user, :email => email)
  u.valid?.should be_false
end

Then(/^I should( not)? be able to add a user of type (.*)$/) do |should_not, u_type|
  u = FactoryGirl.build(:user, :u_type => u_type)
  if should_not
    u.valid?.should be_false
  else
    u.valid?.should be_true
  end
end

