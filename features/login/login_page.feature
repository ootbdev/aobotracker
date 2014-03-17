@login
Feature: Login and logout

In order to login into the site as a user
I have a login page

Background:
  Given I have 2 employees
  And I am on the index page

Scenario: The index page is the login page
  Then I should see "Please login"

Scenario: The login page has a list of users
  Then I should see the names and user types of all users

Scenario: The user can login from the list of users
  When I click on user 1
  Then I should be logged in as user 1
  
Scenario: The user can tell he is logged in
  When I click on user 1
  Then  I should be on the home page
  And I should see the name of user 1
  And I should not see the name of user 2
  And I should see the user type of user 1
  And I should see a link "Log out"

Scenario: The user can log out successfully
  Given I am logged in as user 1
  When I click on "Log out"
  Then I should not be logged in
  And I should be on the index page

Scenario: The user cannot access the home page if he's not logged in
  Given I am logged out
  When I go to the home page
  Then I should be on the index page
