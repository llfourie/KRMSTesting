class KRMSManageEnrollmentEligibilityPage < BasePage

  expected_element :selectAgenda

  wrapper_elements

  element(:selectAgenda) { |b| b.select(name: "agendaType") }
  element(:selectRule) { |b| b.select(name: "ruleType") }
end