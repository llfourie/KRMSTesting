class EnrollmentEligibility < BasePage

  expected_element :select_agenda

  wrapper_elements

  element(:select_agenda) { |b| b.select(name: "agendaType") }
  element(:select_rule) { |b| b.select(name: "ruleType") }
  element(:tab_one) { |b| b.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u86_tab")}
  element(:tab_two) { |b| b.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u99_tab")}
  element(:tab_three) { |b| b.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u112_tab")}
  element(:tab_four) { |b| b.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u948_tab")}
end