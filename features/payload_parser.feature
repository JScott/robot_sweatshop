Feature: Payload Parser
  Parses payloads from the queue

  Background:
    Given nothing is in the 'raw-payload' queue

  Scenario: Parsing BitBucket payloads
    Given a BitBucket payload is put in the 'raw-payload' queue
    Then the payload is parsed to the appropriate hash
    And the payload is pushed to the 'parsed-payload' queue

  #Scenario: Parsing GitHub payloads
  #  Given a GitHub payload is put in the 'raw-payload' queue
  #  Then the payload is parsed to the appropriate hash
  #  And the payload is pushed the 'parsed-payload' queue

  Scenario: Parsing malformed payloads
    Given a malformed payload is put in the 'raw-payload' queue
    Then the payload is parsed to nil
    And the payload is not pushed to the 'parsed-payload' queue
