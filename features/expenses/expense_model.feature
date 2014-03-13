@expense @model
Feature: Expense

In order to track expenses assigned to employees and managers
I want to manage expenses

Background:
  Given I have 2 employees
  And I have 1 manager
  And I have 1 administrator
  And I have 1 ExpenseType
  And I have 0 expenses

Scenario: An expense belongs to a user
  When employee 1 creates an expense
  And employee 2 creates an expense
  And employee 2 creates an expense
  Then expense 1 should belong to employee 1
  And expense 2 should belong to employee 2
  And expense 3 should belong to employee 2

Scenario: An expense must belong to a user
  When I try to create an expense that doesn't belong to any user
  Then I should still have 0 expenses

Scenario Outline: All of the fields (except for reimbursed) for an expense must be non-empty
  When employee 1 tries to create an expense with no <field>
  Then I should still have 0 expenses

  Examples:
    | field         |
    | ExpenseType   |
    | description   |
    | date          |
    | amount        |
    | currency      |

Scenario: An expense can not be assigned to an administrator
  When administrator 1 tries to create an expense
  Then I should still have 0 expenses

Scenario: A user can have many expenses which are completely identical
  Given employee 1 has an expense
  When employee 1 tries to create an expense that is identical to expense 1
  Then employee 1 should have 2 expenses

Scenario Outline: An expense's currency can only be USD or CNY
  When employee 1 tries to create an expense with currency <currency>
  Then employee 1 should have <count> expenses

  Examples:
  | currency | count |
  | USD      | 1     |
  | CNY      | 1     |
  | NOK      | 0     |

@wip
Scenario: An expense type cannot be deleted if there are expenses in the system associated with that type
  Given employee 1 has created an expense with ExpenseType "equipment" 
  Then manager 1 should not be able to delete the ExpenseType "equipment"

@wip
Scenario: All of the expenses associated with a user are deleted if that user is deleted
  Given employee 1 has 5 expenses
  When employee 1 is deleted
  Then I should have 0 expenses

@wip
Scenario: An employee cannot mark an expense as reimbursed or not reimbursed, but a manager can
  Given employee 1 has 1 expense
  And expense 1 has not been reimbursed
  Then employee 1 should not be able to set expense 1 to be reimbursed
  And employee 2 should not be able to set expense 1 to be reimbursed
  And manager 1 should be able to set expense 1 to be reimbursed

Scenario Outline: An employee can change the attributes of his own expenses (except for reimbursed)
  Given I have an ExpenseType "recreation"
  And employee 1 has 1 expense
  When employee 1 sets the <field> of expense 1 to "<value>"
  Then the <field> of expense 1 should be "<value>"

  Examples:
  | field        | value            |
  | ExpenseType  | recreation       |
  | description  | watching a movie |
  | date         | 1980-04-30       |
  | amount       | 1.50             |
  | currency     | USD              |

Scenario Outline:
  Given I have an ExpenseType "recreation"
  And employee 1 has 1 expense
  When employee 2 sets the <field> of expense 1 to "<value>"
  Then the <field> of expense 1 should not be "<value>"

  Examples:
  | field        | value            |
  | ExpenseType  | recreation       |
  | description  | watching a movie |
  | date         | 1980-04-30       |
  | amount       | 1.50             |
  | currency     | USD              |

Scenario Outline: A manager can change the attributes of other's epxenses
  Given I have an ExpenseType "recreation"
  And employee 1 has 1 expense
  When manager 1 sets the <field> of expense 1 to "<value>"
  Then the <field> of expense 1 should be "<value>"

  Examples:
  | field        | value            |
  | ExpenseType  | recreation       |
  | description  | watching a movie |
  | date         | 1980-04-30       |
  | amount       | 1.50             |
  | currency     | USD              |
