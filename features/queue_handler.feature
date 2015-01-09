Feature: Queue Handler
  Pushes and pops items off the requested queues

  Background:
    Given nothing is in the 'test-queue' queue
    And I am a connected client

  Scenario: Pop empty
    When I request 'test-queue'
    Then I receive ''

  Scenario: Push and pop
    When I request 'test-queue item'
    And I request 'test-queue'
    Then I receive 'item'
