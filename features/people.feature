Feature: Managing users

  Background:
    Given I am an authenticated person with admin privileges

  Scenario: Adding a new person
    When I visit "/people"
    And I click on "Create a new agent"
    And I fill in the form with:
    | forname | John |
    | surname | Doe |
    | email | joe@Example.com |
