Feature: Payload Parser
  Parses payloads from the queue

  Background:
    Given nothing is in the 'raw-payload' queue

  Scenario Outline: Parsing BitBucket payloads
    Given a <Source> payload is put in the 'raw-payload' queue
    Then the payload is parsed
    And a hash summary is pushed to the 'parsed-payload' queue
    Examples:
      | Source |
      | BitBucket |

  Scenario: Parsing malformed payloads
    Given a malformed payload is put in the 'raw-payload' queue
    Then the payload is parsed to nil
    And nothing is pushed to the 'parsed-payload' queue

  Scenario: Drop-in custom parsers
