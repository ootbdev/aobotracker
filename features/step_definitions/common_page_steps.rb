Given(/^I am on the index page$/) do
  visit root_path
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content text
end

When(/^I click on (#{USER})$/) do | user |
  click_on "#{user.firstname} #{user.lastname} #{user.u_type}"
end

Then(/^I should be on the home page$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the name of user (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see the name of user (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the user type of user (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a link "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
