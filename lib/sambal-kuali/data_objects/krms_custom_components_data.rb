class KRMSCustomComponentsData
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include PopulationsSearch

  attr_accessor :course, :gpa, :test_score, :test_name, :department, :organization, :grade_select

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :course=>random_alphanums.strip,
        :gpa=>0.0,
        :test_score=>0,
        :test_name=>random_alphanums.strip,
        :department=>random_alphanums.strip,
        :organization=>random_alphanums.strip
    }
    options = defaults.merge(opts)

    set_options(options)
  end
end