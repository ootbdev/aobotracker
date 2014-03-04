@user @model
Feature: User

In order to have a user
I want to have it have a first name, last name, email address, and user type.

Scenario: No two users can have the same email address
  Given I have one user with an email address: test@example.com
  Then I should not be able to add a user with an email address: test@example.com

Scenario: Users must have a first name, last name, email address, and user type
  Given I have no users
  When I add a user with the first name: John, the last name: Smith, email address: test@example.com, and user type: employee
  Then I should have a user with the first name: John, the last name: Smith, email address: test@example.com, and user type: employee

Scenario Outline: User fields cannot be blank
  When I add a user with the first name: John, the last name: Smith, email address: test@example.com, and user type: employee
  Then I should not be able to set a blank <user field> for user with email address: test@example.com

  Examples:
  | user field    |
  | first name    |
  | last name     |
  | email address |
  | user type     |

Scenario Outline: User type can only be employee, manager, or administrator
  Given I have no users
  Then I <should or should not> be able to add a user of type <user type>

  Examples:
  | should or should not | user type     |
  | should               | employee      |
  | should               | manager       |
  | should               | administrator |
  | should not           | avery         |

Scenario: There can only be one administrator
  Given I have one user of type administrator
  Then I should not be able to add a user of type administrator
