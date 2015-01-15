Feature: Payload Parser
  Parses payloads from the queue

  Background:
    Given nothing is in the 'raw-payload' queue
    And nothing is in the 'parsed-payload' queue
    And queue mirroring is enabled

  Scenario: Parses from raw-payload into parsed-payload
    Given I am a connected client
    When Bitbucket payload data is put in the 'raw-payload' queue
    And I wait a second
    Then requesting 'raw-payload' returns ''
    And requesting 'mirror-parsed-payload' returns something

  Scenario Outline: Parsing valid payloads
    Given I am a connected client
    When <Source> payload data is put in the 'raw-payload' queue
    And I wait a second
    And I request 'mirror-parsed-payload'
    Then I receive a standardized hash of payload data
    Examples:
      | Source |
      | Bitbucket |

  Scenario: Parsing malformed payloads
    #And nothing is pushed to the 'parsed-payload' queue
    #When a malformed payload is put in the 'raw-payload' queue

  Scenario: Drop-in custom parsers
