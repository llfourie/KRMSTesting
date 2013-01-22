When /^I select the Select Agenda dropdown$/ do
  go_to_krms_manage_eligibilty
  on EnrollmentEligibility do |page|
    page.select_agenda.click
  end
end

When /^I select the Select Rule dropdown$/ do
  on EnrollmentEligibility do |page|
    page.select_rule.click
  end
end

When /^I select the "(.*)" option from "(.*)" list$/ do |option, select|
  selection = {"Select Agenda"=>:agendaType, "Select Rule"=>:ruleType}
  on EnrollmentEligibility do |page|
    page.select(name: selection[select]).select /#{option}/
  end
end

Then /^there should be "(.*)" possible selections for "(.*)"$/ do |num, select|
  selection = {"Select Agenda"=>:agendaType, "Select Rule"=>:ruleType}
  on EnrollmentEligibility do |page|
    selectList = page.send(selection[select])
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

Then /^these tabs should be visible:$/ do |table|
  on EnrollmentEligibility do |page|
    @tabs = table.raw
    @tabs[0].should eq page.tab_one.text
    @tabs[1].should eq page.tab_two.text
    @tabs[2].should eq page.tab_three.text
    @tabs[3].should eq page.tab_four.text
  end
end