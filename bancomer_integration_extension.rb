# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class BancomerIntegrationExtension < Spree::Extension
  version "1.0"
  description "Bancomer Integration for Spree"
  url "http://github.com/calas/spree-bancomer-integration"

  # Please use bancomer_integration/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "bancomer-active_merchant", :version => '>=0.0.4', :lib => 'active_merchant/bancomer'
  #   config.gem "money"
  # end

  def activate
    require File.join(BancomerIntegrationExtension.root, 'lib/active_merchant/bancomer')

    Billing::Bancomer.register

    base = File.dirname(__FILE__)
    Dir.glob(File.join(base, "app/**/*_decorator*.rb")) do |c|
      RAILS_ENV=="production" ? require(c) : load(c)
    end
  end
end
