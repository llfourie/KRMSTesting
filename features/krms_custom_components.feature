@draft
Feature: KRMS Single Course

Check to see if result is true when valid course is given and false otherwise

  Background:
    Given I am logged in as admin

  Scenario: Return true for valid single course
    When I search for a "Single Course" with text "math212"
    Then the text "MATH212" should exist in the results

  Scenario: Return false for invalid single course
    When I search for a "Single Course" with text "aaaa212"
    Then the text "AAAA212" should not exist in the results

  Scenario Outline: Return false for incorrect GPA entered
    When I enter "<num>" in the "<field>" text field
    Then there should be an error message above the "<field>" text field

    Examples:
    | num | field |
    | 1   | GPA   |
    | 123 | GPA   |

  Scenario: Return true for correct GPA entered
    When I enter "1.2" in the "GPA" text field
    Then there should be no error message above the "GPA" text field

  Scenario: Return true for correct Department entered
    When I search for a "Department" with text "mathematics dept"
    Then the text "Mathematics Dept" should exist in the results

  Scenario: Return false for incorrect Department entered
    When I search for a "Department" with text "political science department"
    Then the text "Political Science Department" should not exist in the results

  Scenario: Return true for correct Organization entered
    When I search for an "Organization" with text "music dept"
    Then the text "Music Dept" should exist in the results

  Scenario: Return false for incorrect Organization entered
    When I search for an "Organization" with text "computer science department"
    Then the text "Computer Science Department" should not exist in the results

  Scenario: Return true for correct Test Name entered
    When I search for a "Test Name" with text "act math"
    Then the text "ACT Math" should exist in the results

  Scenario: Return false for incorrect Test Name entered
    When I search for a "Test Name" with text "adt science"
    Then the text "ADT Science" should not exist in the results

  Scenario Outline: Return false for incorrect Test Score entered
    When I enter "<num>" in the "<field>" text field
    Then there should be an error message above the "<field>" text field

    Examples:
    | num   | field      |
    | 12.3  | Test Score |
    | -12.3 | Test Score |

  Scenario: Return true for correct Test Score entered
    When I enter "20" in the "Test Score" text field
    Then there should be no error message above the "Test Score" text field