When /^I select the Select Agenda dropdown$/ do
  @krmsmanageenroll = make KRMSManageEnrollmentEligibilityData
  go_to_krms_manage_eligibilty
  on KRMSManageEnrollmentEligibilityPage do |page|
    page.selectAgenda.click
  end
end

When /^I select the Select Rule dropdown$/ do
  on KRMSManageEnrollmentEligibilityPage do |page|
    page.selectRule.click
  end
end

When /^I select the "(.*)" option from "(.*)" list$/ do |option, selection|
  if selection == "Select Agenda"
    selection = "agendaType"
  elsif selection == "Select Rule"
    selection = "ruleType"
  end
  on KRMSManageEnrollmentEligibilityPage do |page|
    page.select(name: selection).click
    page.select(name: selection).select /#{option}/
  end
end

Then /^there should be "(.*)" possible selections for "(.*)"$/ do |num, selection|
  on KRMSManageEnrollmentEligibilityPage do |page|
    if selection == "Select Agenda"
      selectList = page.selectAgenda
    elsif selection == "Select Rule"
      selectList = page.selectRule
    end
    selectContent = selectList.options.map(&:text)
    count = 0
    selectContent.each do |content|
      if content == ""
      else
        count += 1
      end
    end
    count.to_s.should eq num
  end

  sleep 10
end

Then /^these tabs should be visible "(.*)", "(.*)", "(.*)", "(.*)"$/ do |tab1, tab2, tab3, tab4|
  on KRMSManageEnrollmentEligibilityPage do |page|
    tab1.should eq page.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u86_tab").text
    tab2.should eq page.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u99_tab").text
    tab3.should eq page.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u112_tab").text
    tab4.should eq page.div(id: "Enrollment-Eligibility-TabSection_tabs").a(href: "#u948_tab").text
  end
end