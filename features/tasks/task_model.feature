@task @model
Feature: Task

In order to track tasks assigned to employees and managers
I want to manage tasks

Background:
  Given I have 2 employees
  And I have 1 administrator
  And I have 1 task type
  And I have 0 tasks

Scenario: A task belongs to a user
  When employee 1 creates a task
  And employee 2 creates a task
  And employee 2 creates a task
  Then task 1 should belong to employee 1
  And task 2 should belong to employee 2
  And task 3 should belong to employee 2

Scenario: A task must belong to a user
  When I try to create a task that doesn't belong to any user
  Then I should still have 0 tasks

Scenario Outline: All of the fields for a task must be non-empty
  When employee 1 tries to create a task with no <field>
  Then I should still have 0 tasks

  Examples:
    | field           |
    | task type       |
    | description     |
    | start date/time |
    | end date/time   |

Scenario: A task can not be assigned to an administrator
  When administrator 1 tries to create a task
  Then I should still have 0 tasks

Scenario: A user can have many tasks which have identical task types and decriptions.
  Given employee 1 has a task with description "development"
  When employee 1 tries to create a task with description "development"
  Then employee 1 should have 2 tasks

Scenario Outline: A user is not allowed to have 2 tasks that overlap in time
  Given employee 1 has a task that starts at "2014-03-06 12:00" and ends at "2014-03-06 13:00"
  When employee 1 tries to create a task that starts at "<start_time>" and ends at "<end_time>"
  Then employee 1 should have <count> tasks

  Examples:
  | start_time       | end_time         | count |
  | 2014-03-06 11:00 | 2014-03-06 11:59 | 2     |
  | 2014-03-06 11:00 | 2014-03-06 12:00 | 2     |
  | 2014-03-06 11:00 | 2014-03-06 12:30 | 1     |
  | 2014-03-06 11:00 | 2014-03-06 13:00 | 1     |
  | 2014-03-06 11:00 | 2014-03-06 14:00 | 1     |
  | 2014-03-06 12:00 | 2014-03-06 12:30 | 1     |
  | 2014-03-06 12:00 | 2014-03-06 13:00 | 1     |
  | 2014-03-06 12:00 | 2014-03-06 14:00 | 1     |
  | 2014-03-06 12:30 | 2014-03-06 12:45 | 1     |
  | 2014-03-06 12:30 | 2014-03-06 13:00 | 1     |
  | 2014-03-06 12:30 | 2014-03-06 14:00 | 1     |
  | 2014-03-06 12:59 | 2014-03-06 14:00 | 1     |
  | 2014-03-06 13:00 | 2014-03-06 14:00 | 2     |
  | 2014-03-06 13:01 | 2014-03-06 14:00 | 2     |

Scenario Outline: A tasks end time has to be greater than it's start time
  When employee 1 tries to create a task that starts at "<start_time>" and ends at "<end_time>"
  Then employee 1 should have <count> tasks

  Examples:
  | start_time       | end_time         | count |
  | 2014-03-06 11:00 | 2014-03-06 11:00 | 0     |
  | 2014-03-06 11:00 | 2014-03-06 11:01 | 1     |
  | 2014-03-06 11:01 | 2014-03-06 11:00 | 0     |
  | 2014-03-05 11:00 | 2014-03-06 11:00 | 1     |
  | 2014-03-06 11:00 | 2014-03-05 11:00 | 0     |

Scenario: A task type of a task should not be able to be destroyed
  Given I have 1 task
  When I try to destroy the task type
  Then that task type should still exist

Scenario: A task type of a task should not be able to be set to nil
  Given I have 1 task
  Then I should not be able to set the task type to nil

Scenario: A user that is deleted should delete all associated tasks.
  Given employee 1 has 5 tasks
  When I delete employee 1
  Then I should have no tasks

