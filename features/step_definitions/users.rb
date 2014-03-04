Given(/^I have no users$/) do
  User.count.should == 0
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

When(/^I set the (.*) for user with email address: ([[:alpha:].]+@[[:alpha:].]+) to "(.*?)"$/) do |u_field, email, value|
  myUser = User.find_by_email(email)
  myUser.should_not be_nil
  case u_field
    when "first name"
    myUser.firstname = value
    when "last name"
    myUser.lastname = value
    when "email address"
    myUser.email = value
  end
  myUser.save
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

