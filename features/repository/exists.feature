Feature: Repositories listing
  In order to be able to check know if a repository still exists
  As a developer
  I want to check that on the service

  @kalibro_restart
  Scenario: With existing project repository
    Given I have a project with name "Kalibro"
    And I have a configuration with name "Java"
    And the given project has the following Repositories:
      |   name    | type |              address                  |
      | "Kalibro" |  GIT | https://github.com/mezuro/kalibro.git |
    When I ask to check if the given repository exists
    Then I should get true
