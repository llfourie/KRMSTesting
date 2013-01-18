@draft
Feature: KRMS Manage Enrollment Eligibility

  Check to see if I all elements are present on the Manage Enrollment Eligibility page

  Background:
    Given I am logged in as admin

  Scenario: Count the number of elements in the Agenda dropdown list
    When I select the Select Agenda dropdown
    Then there should be "4" possible selections for "Select Agenda"
    And there should be "0" possible selections for "Select Rule"

  Scenario: Count the number of elements in the Rule dropdown list
    When I select the Select Agenda dropdown
    And I select the "enrollmentEligibility" option from "Select Agenda" list
    And I select the Select Rule dropdown
    Then there should be "5" possible selections for "Select Rule"

  Scenario: Count the number of elements in the Rule dropdown list
    When I select the Select Agenda dropdown
    And I select the "eligibility" option from "Select Agenda" list
    And I select the Select Rule dropdown
    Then there should be "1" possible selections for "Select Rule"

  Scenario: Confirm that tabs appear when selecting a rule
    When I select the Select Agenda dropdown
    And I select the "enrollmentEligibility" option from "Select Agenda" list
    And I select the "antireq" option from "Select Rule" list
    Then these tabs should be visible "Preview Canonical", "Preview CO", "Edit with Object", "Edit with Logic"