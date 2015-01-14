Feature: Payload Parser
  Parses payloads from the queue

  Scenario Outline: Grabs work from raw-payload
    Given nothing is in the 'raw-payload' queue
    Then I expect payload parsing to happen
    And something is pushed to the 'parsed-payload' queue
    When a <Source> payload is put in the 'raw-payload' queue
    #Then 'raw-payload' is empty
    Examples:
      | Source |
      | Bitbucket |

  Scenario: Parsing malformed payloads
    Given nothing is in the 'raw-payload' queue
    Then I expect payload parsing to happen
    And nothing is pushed to the 'parsed-payload' queue
    When a malformed payload is put in the 'raw-payload' queue

  Scenario: Drop-in custom parsers
