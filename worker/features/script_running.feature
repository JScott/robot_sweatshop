Feature: Script running
  As a developer
  I can rely on the Worker to run my scripts
  So that I generate useful metrics

  Scenario: Run a command
    When I run a command
    Then it has access to the job configuration
    And the output and exit status log to stdout

  Scenario: Run from workspace
    When I run a command
    Then the working directory is the worker's workspace 
    And files read and write to the worker's workspace

  Scenario: Custom logger
    Given that I'm using a custom logger
    When I run a script
    Then the output and exit status log accordingly
