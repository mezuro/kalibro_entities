Feature: Repositories listing
  In order to be able to visualize repositories
  As a developer
  I want to see all the repository from a given project

  @kalibro_restart
  Scenario: With existing project repository
    Given I have a project with name "Kalibro"
    And I have a configuration with name "Java"
    And the given project has the following Repositories:
      |   name    | type |              address                  |
      | "Kalibro" |  GIT | https://github.com/mezuro/kalibro.git |
    When I ask for repositories from the given project
    Then I should get a list with the given repository
    And the repositories should contain the project id