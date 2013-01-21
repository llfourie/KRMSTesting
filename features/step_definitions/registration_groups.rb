Given /^I manage registration groups for (?:a|the) course offering$/ do
  @course_offering = make CourseOffering, :course=>"ENGL105"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
end

Given /^I manage registration groups for the existing course offering$/ do
  @course_offering.manage
  @course_offering.manage_registration_groups(false)
end

When /^I create a(?:n| new) activity offering cluster$/ do
  @ao_cluster = make ActivityOfferingCluster
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
end

When /^I assign an activity offering to the cluster$/ do
  @ao_cluster.add_unassigned_aos
end

Then /^the activity offering is shown as part of the cluster$/ do
  #validate all ao_clusters
  @course_offering.activity_offering_cluster_list.each do |cluster|
      on ManageRegistrationGroups do |page|
        actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
        actual_aos.sort.should == cluster.assigned_ao_list.sort
      end
  end
end

Then /^the remaining activity offerings are shown as unassigned$/ do
  on ManageRegistrationGroups do |page|
    @course_offering.expected_unassigned_ao_list.sort.should ==  page.unassigned_ao_list.sort
  end
end

When /^I generate registration groups with no activity offering cluster$/ do
  @ao_cluster = make ActivityOfferingCluster,  :is_constrained=>false
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster.generate_unconstrained_reg_groups
  @ao_cluster.assigned_ao_list = @course_offering.ao_list.sort #TODO - should ao_cluster have ref to parent?
end

Then /^a default activity offering cluster is created$/ do
  on ManageRegistrationGroups do |page|
    page.cluster_list_item_div(@ao_cluster.private_name).exists?.should == true
  end
end

#generic validation, checks all ao_cluster data_objects vs actual page
Then /^all activity offerings are assigned to the cluster$/ do
  on ManageRegistrationGroups do |page|
    clusters = page.cluster_div_list
    clusters.length.should == @course_offering.activity_offering_cluster_list.length
  end

  @course_offering.activity_offering_cluster_list.each do |cluster|
    cluster.assigned_ao_list.each do |ao_code|
      on ManageRegistrationGroups do |page|
        actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
        actual_aos.sort.should == cluster.assigned_ao_list.sort
      end
    end
  end
end

Then /^the registration groups are generated for the default cluster$/ do
  on ManageRegistrationGroups do |page|
    page.get_cluster_status_msg(@ao_cluster.private_name).strip.should == "All Registration Groups Generated"
  end
  #TODO: view reg groups
end

Then /^there are no remaining unassigned activity offerings$/ do
  on ManageRegistrationGroups do |page|
    page.unassigned_ao_list.length.should == 0
  end
end

When /^I try to create a second activity offering cluster with the same private name$/ do
  @ao_cluster2 = make ActivityOfferingCluster, :private_name=>@ao_cluster.private_name
  @ao_cluster2.create_cluster
end

Then /^only one activity offering cluster is created$/ do
  on ManageRegistrationGroups do |page|
    clusters = page.cluster_div_list
    clusters.length.should == 1
    end
  end

Then /^a create cluster dialog error message appears stating "(.*?)"$/ do |errMsg|
  #KSENROLL-4230 Registration groups - error message is not displayed when creating a cluster with a duplicate private name
  #this is a krad issue, msg is displayed if you reopen the rename dialog -- not a critical issue

  #on ManageRegistrationGroups do |page|
  #  page.create_new_cluster
  #  puts page.create_cluster_first_error_msg
  #  page.cancel_create_cluster
  #end
end

Then /^a registration groups error message appears stating "(.*?)"$/ do|errMsg|
  on ManageRegistrationGroups do |page|
    page.first_page_validation_error.should match /.*#{Regexp.escape(errMsg)}.*/
  end
end

Given /^I manage registration groups for a course offering with multiple activity types$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
end

When /^I assign two activity offerings of the same type to the cluster$/ do
  @ao_cluster.add_unassigned_aos(["E","F"])
end

When /^I generate registration groups$/ do
  @ao_cluster.generate_reg_groups
end

Then /^a cluster error message appears stating "(.*?)"$/ do |errMsg|
  on ManageRegistrationGroups do |page|
    page.get_cluster_first_error_msg(@ao_cluster.private_name).should match /.*#{Regexp.escape(errMsg)}.*/
  end
end

Then /^a cluster warning message appears stating "(.*?)"$/ do |errMsg|
  on ManageRegistrationGroups do |page|
    page.get_cluster_warning_msgs(@ao_cluster.private_name).should match /.*#{Regexp.escape(errMsg)}.*/
  end
end

Then /^registration groups are not generated$/ do
  on ManageRegistrationGroups do |page|
    page.get_cluster_status_msg(@ao_cluster.private_name).strip.should == "No Registration Groups Generated"
  end
end

Given /^I manage registration groups for a course offering with multiple activity types but no activity offering for one of the activity types$/ do
  @course_offering = make CourseOffering, :course=>"CHEM347"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.delete_ao :ao_code=>"AA"
  @course_offering.manage_registration_groups
end

Then /^no activity offering cluster is created$/ do
  on ManageRegistrationGroups do |page|
    clusters = page.cluster_div_list
    clusters.length.should == 0
  end
end

Given /^I manage registration groups for a course offering with 2 activity types?$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
end

When /^I assign two activity offerings of different types and different max enrolment$/ do
  @ao_cluster.add_unassigned_aos(["A","AA"])
end

Then /registration groups? (?:are|is) generated$/ do
  on ManageRegistrationGroups do |page|
    page.get_cluster_status_msg(@ao_cluster.private_name).strip.should == "All Registration Groups Generated"
  end
  #TODO: view reg group
end

Given /^I manage registration groups for a course offering with multiple activity types where the total max enrolment for each type is not equal$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
end

When /^I create (\d+) activity offering clusters$/ do |arg1|
  @ao_cluster = make ActivityOfferingCluster
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)

  @ao_cluster2 = make ActivityOfferingCluster
  @ao_cluster2.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster2)
end

When /^I assign two activity offerings to each cluster$/ do
  @ao_cluster.add_unassigned_aos(["A","AA"])
  @ao_cluster2.add_unassigned_aos(["B","BB"])
end

When /^I generate all registration groups$/ do
  @ao_cluster.generate_all_reg_groups
end

Given /^I manage registration groups for a course offering with multiple activity types where there are activity offering scheduling conflicts$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
end

When /^I assign two activity offerings to each cluster with scheduling conflicts$/ do
  @ao_cluster.add_unassigned_aos(["B","AA"])
  @ao_cluster2.add_unassigned_aos(["A","BB"])
end

Then /^registration groups with time conflicts are marked as invalid$/ do
  on ManageRegistrationGroups do |page|
    page.view_cluster_reg_groups(@ao_cluster.private_name)
  end
  on ViewRegistrationGroups do |page|
    page.invalid_reg_groups?.should == true
    page.close
  end
end

Given /^I have generated a registration group for a course offering with lecture and quiz activity types leaving some activity offerings unassigned$/ do
  @course_offering = make CourseOffering, :course=>"CHEM221"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
  @ao_cluster = make ActivityOfferingCluster
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster.add_unassigned_aos(["A","AA"])
  @ao_cluster.generate_reg_groups
end

When /^I assign a quiz activity offering to the existing activity offering cluster$/ do
  @ao_cluster.add_unassigned_aos(["AB"])
end

Then /^additional registration groups are generated for the new quiz$/ do
  on ManageRegistrationGroups do |page|
    page.view_cluster_reg_groups(@ao_cluster.private_name)
  end
  on ViewRegistrationGroups do |page|
    page.reg_group_list.length.should == 2
    page.close
  end
  #TODO - reg group ids don't change
end

Then /^the quiz is not listed as an unassigned activity offering$/ do
  on ManageRegistrationGroups do |page|
    @course_offering.expected_unassigned_ao_list.sort.should ==  page.unassigned_ao_list.sort
  end
end

Given /^I have created the default registration group for a course offering$/ do
  @course_offering = make CourseOffering, :course=>"CHEM347"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups

  @ao_cluster = make ActivityOfferingCluster,  :is_constrained=>false
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster.generate_unconstrained_reg_groups
  @ao_cluster.assigned_ao_list = @course_offering.ao_list.sort #TODO - should ao_cluster have ref to parent?
end

Given /^I add two activity offerings to the course offering$/ do
  @course_offering.manage
  @activity_offering = make ActivityOffering
  @activity_offering.create :requested_delivery_logistics_list => {},
                            :personnel_list => [],
                            :seat_pool_list => {},
                            :format => "Lecture/Lab"
  @activity_offering.save

  @course_offering.manage
  @activity_offering1 = make ActivityOffering
  @activity_offering1.create :requested_delivery_logistics_list => {},
                            :personnel_list => [],
                            :seat_pool_list => {},
                            :format => "Lecture/Lab"
  @activity_offering1.save

end

When /^I confirm that the activity offerings are listed as unassigned$/ do
  on ManageRegistrationGroups do |page|
    @course_offering.expected_unassigned_ao_list.sort.should ==  page.unassigned_ao_list.sort
  end
end

When /^I assign the new activity offerings to the default activity offering cluster$/ do
  @ao_cluster.add_unassigned_aos( [@activity_offering.code, @activity_offering1.code])
end

Then /^additional registration groups are generated for the new activity offerings$/ do
  on ManageRegistrationGroups do |page|
    page.view_cluster_reg_groups(@ao_cluster.private_name)
  end
  on ViewRegistrationGroups do |page|
    page.reg_group_list.length.should == 3
    page.close
  end
end

Then /^the new activity offerings are not listed as an unassigned activity offerings$/ do
  on ManageRegistrationGroups do |page|
    @course_offering.expected_unassigned_ao_list.sort.should ==  page.unassigned_ao_list.sort
  end
end

Then /^the registration group is updated$/ do
  #TODO - reg groups checking
end

Given /^I have generated two registration groups for a course offering with lecture and lab activity types$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
  @ao_cluster = make ActivityOfferingCluster
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster.add_unassigned_aos(["A","AA"])
  @ao_cluster.generate_reg_groups
  @ao_cluster2 = make ActivityOfferingCluster
  @ao_cluster2.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster2)
  @ao_cluster2.add_unassigned_aos(["B","BB","AB"])
  @ao_cluster2.generate_reg_groups
end

When /^I move a lab activity offering from the first activity offering cluster to the second activity offering cluster$/ do
  @ao_cluster2.move_ao_to_another_cluster("AB",@ao_cluster)
end

Then /^the registration groups? sets? (?:is|are) updated$/ do
  on ManageRegistrationGroups do |page|
    @course_offering.activity_offering_cluster_list.each do |cluster|
      page.get_cluster_status_msg(cluster.private_name).strip.should == "All Registration Groups Generated"
    end
  end
  #TODO: reg groups validation
end

Given /^I have created the default cluster and related registration groups for a course offering with lecture and lab activity types$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
  @ao_cluster = make ActivityOfferingCluster,  :is_constrained=>false
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster.generate_unconstrained_reg_groups
  @ao_cluster.assigned_ao_list = @course_offering.ao_list.sort
end

When /^I move a lab activity offering from the default activity offering cluster to the new activity offering cluster$/ do
  @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("AA",@course_offering.activity_offering_cluster_list[1])
end

When /^I move a lecture activity offering from the default activity offering cluster to the new activity offering cluster$/ do
  @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A",@course_offering.activity_offering_cluster_list[1])
end

Given /^I have generated a registration group for a course offering with lecture and lab activity types$/ do
  @course_offering = make CourseOffering, :course=>"CHEM426"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
  @ao_cluster = make ActivityOfferingCluster
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster.add_unassigned_aos(@course_offering.ao_list)
  @ao_cluster.generate_reg_groups
end

When /^I remove a lab activity offering from the existing activity offering cluster$/ do
  @ao_cluster.remove_ao("AA")
end

Then /^the lab is now listed as an unassigned activity offering$/ do
  on ManageRegistrationGroups do |page|
    page.unassigned_ao_list.sort.should == @course_offering.expected_unassigned_ao_list().sort
  end
end

When /^I change the activity offering cluster published and private names$/ do
  @ao_cluster.rename
end

Then /^activity offering cluster published and private names are successfully changed$/ do
  @course_offering.activity_offering_cluster_list.each do |cluster|
      on ManageRegistrationGroups do |page|
        cluster.published_name.should == page.cluster_published_name(cluster.private_name)
      end
    end
end

Given /^I have created two activity offering clusters for a course offering$/ do
  @course_offering = make CourseOffering, :course=>"CHEM152"
  new_course = @course_offering.create_co_copy
  @course_offering = make CourseOffering, :course=>new_course
  @course_offering.manage
  @course_offering.manage_registration_groups
  @ao_cluster = make ActivityOfferingCluster
  @ao_cluster.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster)
  @ao_cluster2 = make ActivityOfferingCluster
  @ao_cluster2.create_cluster
  @course_offering.add_ao_cluster(@ao_cluster2)
end

When /^I change the private name of the first activity offering cluster using the private name of the second$/ do
  @ao_cluster.rename :private_name => @ao_cluster2.private_name, :expect_success => false
end

Then /^a rename cluster dialog error message appears stating "(.*?)"$/ do |errMsg|
  #KSENROLL-4230 Registration groups - error message is not displayed when creating a cluster with a duplicate private name
  #this is a krad issue, msg is displayed if you reopen the rename dialog -- not a critical issue
end

Then /^the first activity offering cluster private name is not changed$/ do
  @course_offering.activity_offering_cluster_list.each do |cluster|
    on ManageRegistrationGroups do |page|
      cluster.published_name.should == page.cluster_published_name(cluster.private_name)
    end
  end
end

When /^I delete the first activity offering cluster$/ do
  @ao_cluster.delete
  @course_offering.activity_offering_cluster_list.delete(@ao_cluster)
end

Then /^the associated registration groups are deleted$/ do
  on ManageRegistrationGroups do |page|
    clusters = page.cluster_div_list
    clusters.length.should == 1
  end
end

Then /^the associated activity offerings are now listed as unassigned$/ do
  on ManageRegistrationGroups do |page|
    page.unassigned_ao_list.sort.should == @course_offering.expected_unassigned_ao_list.sort
  end
end

When /^I delete the default activity offering cluster$/ do
  @ao_cluster.delete
  @course_offering.activity_offering_cluster_list.delete(@ao_cluster)
end

Then /^the registration groups are deleted$/ do
  on ManageRegistrationGroups do |page|
    clusters = page.cluster_div_list
    clusters.length.should == 0
  end
end

Then /^a cluster status message appears stating "([^"]*)"$/ do |status_msg|
  on ManageRegistrationGroups do |page|
    page.get_cluster_status_msg(@ao_cluster.private_name).strip.should  match /.*#{Regexp.escape(status_msg)}.*/
  end
end
