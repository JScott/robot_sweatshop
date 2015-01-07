@run_queue_broadcaster
Feature: Queue Broadcaster
  Publishes to queue channels when the queues are not empty

  Scenario: Publish
    Given something is in the 'jobs' queue
    When I subscribe to the 'jobs' queue
    Then I hear the queue count

  Scenario: But not always
    Given nothing is in the 'jobs' queue
    When I subscribe to the 'jobs' queue
    Then I hear nothing
