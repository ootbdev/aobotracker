aobotracker
===========

Aobo's Time/Expenses Tracker as an RoR Exercise

Description
-----------

This is a basic company tracker that employees can use to track their time spent as well as record expenses.  In addition, managers can generate basic timesheet and expense reports.

Really, though, this isn't a *real* project that any serious company would seriously consider using.  It's a dummy project with basic enough specs which serves as a vehicle for a development team to try out pair programming, practice behavior/test driven development, and grow accustomed to building a Ruby-on-Rails application.

Setup 
-----

1. Make sure you have [installed RVM](http://rvm.io/rvm/install). 
2. Clone this repository: `git clone git@github.com:ootbdev/aobotracker.git`
3. When going to the project folder, accept the usage of `.rvmrc`, which will set the Ruby version to 2.0.0 (and will guide you to installing that version if you don't already have it).
4. Make a local copy of the Gemfile: `cp Gemfile.template Gemfile`
5. `bundle install`
6. Make a local copy of spec_helper: `cp spec/spec_helper.rb.template spec/spec_helper.rb`
7. Make a local copy of Cucumber env: `cp features/support/env.rb.template features/support/env.rb`

Branch Policy
-------------

As a general policy, we only check in code to the `master` branch if the **entire** test suite has been run and there are no failed tests.  But you may find it helpful to commit code and push it to remote even though it is a work in progress and there are still failing tests.  This is especially the case if you are pair programming and quickly need to swap machines - your work-in-progress branch can be pulled down from Github and used right away, minimizing the amount of time lost in switching work machines.

Create your own work-in-progress branch, called `[your-name]-WIP`. Push this branch to Github so that it is available for others too.

Wiki
----

The specs for this project can be found at the [Project Wiki](https://github.com/ootbdev/aobotracker/wiki).
