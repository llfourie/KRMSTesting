class EnrollmentEligibilityData
  include Foundry
  include DataFactory

  attr_accessor :select_agenda, :select_rule

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
    }

    options = defaults.merge(opts)

    set_options(options)
  end
end