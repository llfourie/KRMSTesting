class KRMSManageEnrollmentEligibilityData
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include PopulationsSearch

  attr_accessor :selectAgenda, :selectRule

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
    }

    options = defaults.merge(opts)

    set_options(options)
  end
end