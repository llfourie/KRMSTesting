When /^I search for (?:a|an) "(.*)" with text "(.*)"$/ do |section, code|
  fields = {"Single Course"=>:course, "Department"=>:department, "Organization"=>:organization, "Test Name"=>:test_name}
  go_to_krms_components
  on CustomComponents do |page|
    page.send(fields[section]).set code
  end
  sleep 2
end

Then /^the text "(.*)" should exist in the results$/ do |code|
  on CustomComponents do |page|
    page.auto_message.text.should == code
  end
  sleep 2
end

Then /^the text "(.*)" should not exist in the results$/ do |code|
  on CustomComponents do |page|
    if page.auto_message.exists?
      page.auto_message.text.should_not == code
    end
  end
  sleep 2
end

When /^I enter "(.*)" in the "(.*)" text field$/ do |num, section|
  fields = {"GPA"=>:gpa, "Test Score"=>:test_score}
  go_to_krms_components
  on CustomComponents do |page|
    page.send(fields[section]).set num
  end
end

Then /^the "(.*)" should have an error message$/ do |section|
  fields = {"GPA"=>:gpa, "Test Score"=>:test_score}
  on CustomComponents do |page|
    page.send_keys :tab
    sleep 2
    if page.error_message.exists?
      if fields[section] == "gpa"
        if page.send(fields[section]).text == /^\d$/
          page.error_message.text.should eq "Please enter at least 3 characters."
        elsif page.send(fields[section]).text == /^\d\d\d$/
          page.error_message.text.should eq "Must be a non-zero positive fixed point number, with 2 max digits and 1 digits to the right of the decimal point"
        end
      elsif fields[section] == "test_score"
        page.error_message.text.should eq "Must be a positive whole number"
      end
    end
    page.execute_script("window.confirm = function() {return true}")
    sleep 2
  end
end

Then /^there should be no error message$/ do
  on CustomComponents do |page|
    page.send_keys :tab
    sleep 2
    if page.error_message.exists?
      page.error_message.text.should eq ""
    end
    page.execute_script("window.confirm = function() {return true}")
  end
  sleep 2
end

When /^I select the "(.*)" radio button$/ do |rb|
  go_to_krms_components
  on CustomComponentse do |page|
    page.label(text: rb).click
  end
  sleep 10
end

Then /^there should be "(.*)" possible selections for Grade$/ do |num|
  on CustomComponents do |page|
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