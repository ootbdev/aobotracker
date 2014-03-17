Then(/^I should see the names and user types of all users$/) do
  User.all.each do |user|
    page.should have_content(user.firstname)
    page.should have_content(user.lastname)
    page.should have_content(user.u_type)
  end
end

Then(/^I should be logged in as (#{USER})$/) do |user|
  cookie = get_me_the_cookie("user_id")
  cookie[:value].to_i.should == user.id
end
