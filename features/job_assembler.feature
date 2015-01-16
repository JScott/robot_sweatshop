Feature: Job Assembler
  Parses job requests into real jobs, using payload parser

  Background:
    Given nothing is in the 'job-request' queue
    And nothing is in the 'jobs' queue
    And queue mirroring is enabled
    And I am a connected client
    And I have a simple job configuration

  Scenario: Parses from job-request into jobs
    When a job request is put in the 'job-request' queue
    And I wait a second
    Then requesting 'job-request' returns ''
    And requesting 'mirror-jobs' returns something

  Scenario: Passes work to the payload parser
    Given nothing is in the 'raw-payload' queue
    And nothing is in the 'parsed-payload' queue
    When a job request is put in the 'job-request' queue
    And I wait a second
    Then requesting 'raw-payload' returns ''
    And requesting 'mirror-parsed-payload' returns something

  Scenario: Assembles job requests
    When a job request is put in the 'raw-payload' queue
    And I wait a second
    And I request 'mirror-parsed-payload'
    Then I receive a standardized hash of job data

  Scenario: Requests for branches that aren't whitelisted
    Given I have a job configuration with a branch whitelist
    When a conflicting job request is put in the 'job-request' queue
    And I wait a second
    # TODO: this needs to be more clear that nothing was ever pushed to the queue. Ambiguous, could have pushed ''
    Then requesting 'mirror-jobs' returns ''
    
  # TODO: this should work but isn't in scope right now, thus isn't worth testing
  Scenario: Drop-in custom jobs
