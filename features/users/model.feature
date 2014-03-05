@user @model
Feature: User

In order to have a user
I want to have it have a first name, last name, email address, user type, and a password.

Scenario: No two users can have the same email address
  Given I have one user with an email address: test@example.com
  Then I should not be able to add a user with an email address: test@example.com


Scenario: Users must have a first name, last name, email address, user type, and a password
  Given I have no users
  When I add a user with the first name: John, the last name: Smith, email address: test@example.com, user type: employee, a password: ASDFghjkl; and a password confirmation: ASDFghjkl;
  Then I should have a user with the first name: John, the last name: Smith, email address: test@example.com, user type: employee, and a password: ASDFghjkl;

Scenario Outline: User fields cannot be blank
  When I add a user with the first name: John, the last name: Smith, email address: test@example.com, user type: employee, a password: ASDFghjkl; and a password confirmation: ASDFghjkl;
  Then I should not be able to set a blank <user field> for user with email address: test@example.com

  Examples:
  | user field            |
  | first name            |
  | last name             |
  | email address         |
  | user type             |
  | password              |
  | password confirmation |

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

Scenario Outline: Passwords have to be at least six characters and at the most 256 characters in length
  Given I have no users
  Then I <should or should not> be able to add a user with a password of length <number>

  Examples:
  | number | should or should not |
  |      1 | should not           |
  |      5 | should not           |
  |      6 | should               |
  |    256 | should               |
  |    257 | should not           |

Scenario Outline: Passwords must have at least one non alphabet character
  Given I have no users
  Then I <should or should not> be able to add a user with a password where the number of non alphabet characters is <number>

  Examples:
  | number | should or should not |
  |      0 | should not           |
  |      1 | should               |
  |      2 | should               |
