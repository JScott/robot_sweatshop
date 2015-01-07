@run_queue_handler
Feature: Queue Handler
  Pushes and pops items off the requested queues

  Background:
    Given nothing is in the queue

  Scenario: Pop empty
    When I request 'jobs'
    Then I receive nil

  Scenario: Push/pop
    When I request 'jobs test'
    And I request 'jobs'
    Then I receive 'test'

  Scenario: Push
    When I request 'jobs test'
    And I request 'jobs'
    Then I receive 'test'

