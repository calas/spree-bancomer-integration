require File.join(File.dirname(__FILE__), '/../test_helper')

class BancomerPaymentTest < ActiveSupport::TestCase
  context BancomerPayment do
    should_validate_presence_of :order_id

    context "create from factory" do
      setup { Factory :bancomer_payment }
      should_change("BancomerPayment.count", :by => 1) { BancomerPayment.count }
    end

    context "instance" do
      setup do
        @bancomer_payment = Factory(:bancomer_payment)
      end

      # these two properties now under control of checkout controller
      # should "not be allowed to be changed when have checkout" do
      # should "not be allowed to be changed when have shippment" do
    end

  end
end

