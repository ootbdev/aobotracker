Given(/^I have no users$/) do
  User.count.should == 0
end

Given(/^I have one user of type (.*)$/) do |u_type|
  u = FactoryGirl.create(:user, :u_type => u_type)
end

Given(/^I have one user with an email address: ([[:alpha:].]+@[[:alpha:].]+)$/) do |email|
  FactoryGirl.create(:user, :email => email)
end

When(/^I add a user with the first name: ([[:alpha:]]+), the last name: ([[:alpha:]]+), email address: ([[:alpha:].]+@[[:alpha:].]+), user type: ([[:alpha:]]+), a password: (.*) and a password confirmation: (.*)$/) do | first, last, email, type, password, password_conf | 
  User.create(:firstname => first, :lastname => last, :email => email, :u_type => type, password: password, password_confirmation: password_conf)
end

Then(/^I should( not)? be able to add a user with a password of length (\d+)$/) do |should_not, p_length|
  pass = Faker::Lorem.characters(p_length.to_i)
  u = FactoryGirl.build(:user, :password => pass, :password_confirmation => pass)
  if should_not
    u.valid?.should be_false
  else
    u.valid?.should be_true
  end
end

Then(/^I should( not)? be able to add a user with a password where the number of non alphabet characters is (\d+)$/) do |should_not, num_nonalpha|
  pass = "AAAAAA"
  i = num_nonalpha.to_i
  while i> 0 do
    pass.concat("1")
    i -= 1
  end
  u = FactoryGirl.build(:user, :password => pass, :password_confirmation => pass)
  if should_not
    u.valid?.should be_false
  else
    u.valid?.should be_true
  end
end


Then(/^I should have a user with the first name: ([[:alpha:]]+), the last name: ([[:alpha:]]+), email address: ([[:alpha:].]+@[[:alpha:].]+), user type: ([[:alpha:]]+), and a password: (.*)$/) do | first, last, email, type, password | 
  myUser = User.find_by_email(email) 
  myUser.should_not be_nil
  myUser.firstname.should == first
  myUser.lastname.should == last
  myUser.u_type.should == type
  myUser.authenticate(password).should == myUser
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
    when "password"
    myUser.password = ''
    when "password_confirmation"
    myUser.password_confirmation = ''
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

