Feature: Working from a queue
  As a developer
  I can rely on the Worker to read jobs from the queue
  So that I can publish new jobs to it

  Scenario: Subscribe to a job queue
    When a new job is published
    Then I generate a configuration file
    And run all its commands
