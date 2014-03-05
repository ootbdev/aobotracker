@tasktype @model
Feature: TaskType

In order to categorize tasks
I want to maintain a list of task types

Scenario: No two TaskTypes can have the same name
  Given I have 0 TaskTypes
  When I add a TaskType called: "administration"
  Then I should have 1 TaskType
  And I should not be able to add a TaskType called: "administration"
  And I should not be able to add a TaskType called: "administration "

Scenario Outline: The maximum length of a TaskType is 30 characters and it cannot be blank
  Given I have 0 TaskTypes
  When I add a TaskType called: <task type names>
  Then I should have <count> TaskTypes

  Examples:
  | task type names                                     | count |
  | "administration"                                    | 1     |
  | "insanelylongtasknamefornearinfinitecomplextasks49" | 0     |
  | "insanelylongtasknameendingat30"                    | 1     |
  | ""                                                  | 0     |
