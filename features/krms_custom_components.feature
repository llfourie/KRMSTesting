@draft
Feature: KRMS Single Course

Check to see if result is true when valid course is given and false otherwise

  Background:
    Given I am logged in as admin

  Scenario Outline: Return true for correct string entered
    When I search for a "<field>" with text "<text>"
    Then the text "<result>" should exist in the results

    Examples:
    | field         | text                     | result                   |
    | Single Course | mathm                    | MATHM                    |
    | Department    | cmns-applied mathematics | CMNS-Applied Mathematics |
    | Organization  | arhu-school of music     | ARHU-School of Music     |

  Scenario Outline: Return false for incorrect string entered
    When I search for a "<field>" with text "<text>"
    Then the text "<result>" should not exist in the results

    Examples:
    | field         | text                         | result                       |
    | Single Course | aaaa212                      | AAAA212                      |
    | Department    | political science department | Political Science Department |
    | Organization  | computer science department  | Computer Science Department  |

  Scenario Outline: Return true for correct number entered
    When I enter "<num>" in the "<field>" text field
    Then there should be no error message

    Examples:
    | num | field      |
    | 1.2 | GPA        |
    | 20  | Test Score |

  Scenario Outline: Return false for incorrect number entered
    When I enter "<num>" in the "<field>" text field
    Then the "<field>" should have an error message

    Examples:
    | num   | field      |
    | 1     | GPA        |
    | 123   | GPA        |
    | 12.3  | Test Score |
    | -12.3 | Test Score |

#  Scenario: Return true for correct Test Name entered
#    When I search for a "Test Name" with text "act math"
#    Then the text "ACT Math" should exist in the results
#
#  Scenario: Return false for incorrect Test Name entered
#    When I search for a "Test Name" with text "adt science"
#    Then the text "ADT Science" should not exist in the results