When /^I search for (?:a|an) "(.*)" with text "(.*)"$/ do |section, code|
  @krmstext = make KRMSCustomComponentsData
  go_to_krms_components
  on KrmsCustomComponentsPage do |page|
    if section == "Single Course"
      page.course.set code
    elsif section == "Department"
      page.department.set code
    elsif section == "Organization"
      page.organization.set code
    elsif section == "Test Name"
      page.test_name.set code
    end
  end
  sleep 2
end

Then /^the text "(.*)" should exist in the results$/ do |code|
  on KrmsCustomComponentsPage do |page|
    page.a(class: "ui-corner-all").text.should == code
  end
  sleep 2
end

Then /^the text "(.*)" should not exist in the results$/ do |code|
  on KrmsCustomComponentsPage do |page|
    if page.a(class: "ui-corner-all").exists?
      page.a(class: "ui-corner-all").text.should_not == code
    end
  end
  sleep 2
end

When /^I enter "(.*)" in the "(.*)" text field$/ do |num, section|
  @krmsnum = make KRMSCustomComponentsData
  go_to_krms_components
  on KrmsCustomComponentsPage do |page|
    if section == "GPA"
      page.gpa.set num
    elsif section == "Test Score"
      page.test_score.set num
    end
  end
  sleep 2
end

Then /^there should be an error message above the "(.*)" text field$/ do |section|
  on KrmsCustomComponentsPage do |page|
    if section == "GPA"
      page.test_score.set ""
    elsif section == "Test Score"
      page.test_name.set ""
    end
    sleep 2
    if page.img(class: "uif-errorMessageItem-field").exists?
      if section == "GPA"
        if @krmsnum.gpa == /^\d$/
          page.img(class: "uif-errorMessageItem-field").text.should eq "Please enter at least 3 characters."
        elsif @krmsnum.gpa == /^\d\d\d$/
          page.img(class: "uif-errorMessageItem-field").text.should eq "Must be a non-zero positive fixed point number, with 2 max digits and 1 digits to the right of the decimal point"
        end
      elsif section == "Test Score"
        page.img(class: "uif-errorMessageItem-field").text.should eq "Must be a positive whole number"
      end
    end
    page.execute_script("window.confirm = function() {return true}")
    sleep 2
  end
end

Then /^there should be no error message above the "(.*)" text field$/ do |section|
  on KrmsCustomComponentsPage do |page|
    if section == "GPA"
      page.test_score.set ""
    elsif section == "Test Score"
      page.test_name.set ""
    end
    sleep 2
    if page.img(class: "uif-errorMessageItem-field").exists?
      if section == "GPA"
        page.img(class: "uif-errorMessageItem-field").text.should eq ""
      elsif section == "Test Score"
        page.img(class: "uif-errorMessageItem-field").text.should eq ""
      end
    end
    page.execute_script("window.confirm = function() {return true}")
  end
  sleep 2
end

When /^I select the "(.*)" radio button$/ do |rb|
  @krmsrb = make KRMSCustomComponentsData
  go_to_krms_components
  on KrmsCustomComponentsPage do |page|
    page.label(text: rb).click
  end
  sleep 10
end

Then /^there should be "(.*)" possible selections for Grade$/ do |num|
  on KrmsCustomComponentsPage do |page|
  selectList = page.grade_select
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
  sleep 2
end