Given(/^I am on the (.*) page$/) do |page_identifier|
  visit get_path(page_identifier)
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content text
end

When(/^I click on "([^"]+)"$/) do | link_text |
  click_on link_text
end

When(/^I click on (#{USER})$/) do | user |
  click_on "#{user.firstname} #{user.lastname} #{user.u_type}"
end

When(/^I go to the (.*) page$/) do |page_identifier|
  visit get_path(page_identifier)
end

Then(/^I should be on the (.*) page$/) do |page_identifier|
  current_path.should == get_path(page_identifier)
end

Then(/^I should( not)? see the (.*) of (#{USER})$/) do |should_not, field, user|
  case field
  when 'name'
    content = "#{user.firstname} #{user.lastname}"
  when 'user type'
    content = user.u_type
  end
  if should_not
    page.should_not have_content content
  else
    page.should have_content content
  end
end

Then(/^I should see a link "(.*?)"$/) do |link_text|
  page.should have_link link_text
end

def get_path(page_identifier)
  case page_identifier
  when 'index'
    root_path
  when 'home'
    home_path
  end
end
