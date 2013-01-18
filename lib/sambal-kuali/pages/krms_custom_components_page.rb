class KrmsCustomComponentsPage < BasePage

  expected_element :course

  wrapper_elements

  element(:course) { |b| b.text_field(id: "KRMS-SingleCourse-SuggestField_control") }
  element(:gpa) { |b| b.text_field(id: "KRMS-GPA-Field_control") }
  element(:test_score) { |b| b.text_field(id: "KRMS-TestScore-Field_control") }
  element(:test_name) { |b| b.text_field(id: "KRMS-TestName-Field_control") }
  element(:department) { |b| b.text_field(id: "KRMS-Department-Field_control") }
  element(:organization) { |b| b.text_field(id: "KRMS-Administering-Org-Field_control") }
  element(:grade_select) { |b| b.select(id: "KRMS-GradeValues-Field_control")}

end