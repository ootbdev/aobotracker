@expensetype @model
Feature: ExpenseType

In order to categorize expenses
I want to maintain a list of expense type.

Scenario: No two ExpenseTypes can have the same name
  Given I have 0 ExpenseTypes
  When I add a ExpenseType called: "administration"
  Then I should have 1 ExpenseType
  And I should not be able to add a ExpenseType called: "administration"
  And I should not be able to add a ExpenseType called: "administration "

Scenario Outline: The maximum length of a ExpenseType is 30 characters and it cannot be blank
  Given I have 0 ExpenseTypes
  When I add a ExpenseType called: <expense type names>
  Then I should have <count> ExpenseTypes

  Examples:
  | expense type names                                        | count |
  | "administration"                                          | 1     |
  | "insanelylongexpensenamefornearinfinitecomplexexpenses49" | 0     |
  | "insanelylongexpensenamethats30"                          | 1     |
  | ""                                                        | 0     |
