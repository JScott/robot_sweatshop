Feature: Queue Broadcaster
  Publishes to queue channels when the queues are not empty

  Background:
    Given I subscribe to the 'testing' queue

  Scenario: Publish
    Given something is in the 'testing' queue
    Then I hear 'testing' on 'busy-queues'

  Scenario: But not always
    Given nothing is in the 'testing' queue
    Then I hear nothing
