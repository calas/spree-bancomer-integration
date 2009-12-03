require File.join(File.dirname(__FILE__), '/../../test_helper')

class Billing::BancomerTest < ActiveSupport::TestCase
  context Billing::Bancomer do
    context "create from factory" do
      setup { Factory :billing_bancomer }
      should_change("Billing::Bancomer.count", :by => 1) { Billing::Bancomer.count }
    end

    context "instance" do
      setup do
        @billing_bancomer = Factory(:billing_bancomer)
      end

      should "be the current billing" do
        assert_equal Billing::Bancomer.current, @billing_bancomer
      end

      # these two properties now under control of checkout controller
      # should "not be allowed to be changed when have checkout" do
      # should "not be allowed to be changed when have shippment" do
    end

  end
end

