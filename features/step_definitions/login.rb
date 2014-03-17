Given(/^I am logged in as (#{USER})$/) do |user|
  visit login_path
  click_on "#{user.firstname} #{user.lastname} #{user.u_type}"
end

Given(/^I am logged out$/) do
  visit home_path
  if page.has_selector?('a', :text => 'Log out')
    click_on "Log out"
  end
end

Then(/^I should see the names and user types of all users$/) do
  User.all.each do |user|
    button_value = "#{user.firstname} #{user.lastname} #{user.u_type}"
    page.should have_selector('input[type=submit][value="' + button_value + '"]')
  end
end

Then(/^I should be logged in as (#{USER})$/) do |user|
  cookie = get_me_the_cookie("user_id")
  cookie[:value].to_i.should == user.id
end

Then(/^I should not be logged in$/) do
  cookie = get_me_the_cookie("user_id")
  cookie[:value].empty?.should be_true
end
