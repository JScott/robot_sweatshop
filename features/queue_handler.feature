@run_queue_handler
Feature: Queue Handler
  Pushes and pops items off the requested queues

  Background:
    Given nothing is in the queue

  Scenario: Pop empty
    When I request 'test-queue'
    Then I receive ''

  Scenario: Push and pop
    When I request 'test-queue item'
    And I request 'test-queue'
    Then I receive 'item'
