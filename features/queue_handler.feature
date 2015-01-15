Feature: Queue Handler
  Pushes and pops items off the requested queues

  Background:
    Given nothing is in the 'testing' queue
    And I am a connected client

  Scenario: Pop empty
    When I request 'testing'
    Then I receive ''

  Scenario: Push and pop
    When I request 'testing item'
    And I request 'testing'
    Then I receive 'item'

  Scenario: Mirroring
    Given queue mirroring is enabled
    When I request 'testing item'
    And I request 'mirror-testing'
    Then I receive 'item'
