@task @model
Feature: Task

In order to track tasks assigned to employees and managers
I want to manage tasks

Scenario Outline: A task consists of a task type, a description, a start date/time and end date/time and should have 1 assigned user
  Given I have 0 tasks and a user with email address "superman@northpole.com" and a task type "Administration"
  Then I <should or should not> be able to create 1 task with task type <task-type>, description <description>, start time <start-time>, end time <end-time> assigned to <user-email>

  Examples:
  | task-type        | description             | start-time         | end-time            | user-email               | should or should not |
  | "Administration" | "Bossing people around" | "2014-03-04 07:43" | "2014-03-04  09:00" | "superman@northpole.com" | should               |
#  | ""               | "Bossing people around" | "2014-03-04 07:43" | "2014-03-04  09:00" | "superman@northpole.com" | should not           |
#  | "Administration" | ""                      | "2014-03-04 07:43" | "2014-03-04  09:00" | "superman@northpole.com" | should not           |
#  | "Administration" | "Bossing people around" | ""                 | "2014-03-04  09:00" | "superman@northpole.com" | should not           |
#  | "Administration" | "Bossing people around" | "2014-03-04 07:43" | ""                  | "superman@northpole.com" | should not           |
#  | "Administration" | "Bossing people around" | "2014-03-04 07:43" | "2014-03-04  09:00" | ""                       | should not           |
 
Scenario: A task can not be assigned to an administrator
  Given I have 0 tasks and an administrator user with email address "superman@northpole.com" 
  Then I should not be able to create a task with the user "superman@northpole.com" 

Scenario: A user can have many tasks which have identical task types and decriptions.
  Given I have a user
  Then I should be able to create 2 tasks with identical task types "Development" and descriptions "Not really working"

Scenario Outline: A user is not allowed to have 2 tasks that overlap in time
  Given I have a user with a task where the task type is "Development", the description is "Actually having lunch", the start time is "2014-03-06 12:43" and the end time is "2014-03-06 13:55"
  Then I <should or should not> be able to create a task with start time <start_time> and end time <end_time>

  Examples:
  | should or should not | start_time         | end_time           |
  | should               | "2014-03-06 15:33" | "2014-03-07 00:22" |
  | should               | "2014-03-05 12:22" | "2014-03-06 00:00" |
  | should not           | "2014-03-06 00:00" | "2014-03-06 13:00" |
  | should not           | "2014-03-06 13:00" | "2014-03-07 01:00" |
  | should not           | "2014-03-06 13:00" | "2014-03-06 13:20" |

Scenario: A tasks end time has to be greater than it's start time
  Given I have a user
  Then I should not be able to create a task with end time less or equal to start time

  







 
