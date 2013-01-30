class CustomComponents < BasePage

  expected_element :course

  wrapper_elements
  frame_element

  element(:course) { |b| b.frm_temp.text_field(id: "KRMS-SingleCourse-SuggestField_control") }
  element(:gpa) { |b| b.frm_temp.text_field(id: "KRMS-GPA-Field_control") }
  element(:test_score) { |b| b.frm_temp.text_field(id: "KRMS-TestScore-Field_control") }
  element(:test_name) { |b| b.frm_temp.text_field(id: "KRMS-TestName-Field_control") }
  element(:department) { |b| b.frm_temp.text_field(id: "KRMS-Department-Field_control") }
  element(:organization) { |b| b.frm_temp.text_field(id: "KRMS-Administering-Org-Field_control") }
  element(:grade_select) { |b| b.frm_temp.select(id: "KRMS-GradeValues-Field_control")}
  element(:auto_message) { |b| b.frm_temp.a(class: "ui-corner-all")}
  element(:error_message) { |b| b.frm_temp.img(class: "uif-errorMessageItem-field")}
  element(:radio) { |b| b.frm_temp.fieldset(id: "KRMS-GradeScale-Field_fieldset")}

end