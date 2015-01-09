Feature: Queue Broadcaster
  Publishes to queue channels when the queues are not empty

  Background:
    Given the queue broadcaster is running
    And I subscribe to the 'jobs' queue

  Scenario: Publish
    Given something is in the 'jobs' queue
    Then I hear the queue count

  Scenario: But not always
    Given nothing is in the 'jobs' queue
    Then I hear nothing
