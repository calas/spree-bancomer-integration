require File.join(File.dirname(__FILE__), '/../test_helper')

class BancomerPaymentInfoTest < ActiveSupport::TestCase
  context BancomerPaymentInfo do
    should_validate_presence_of :bancomer_payment_id

    context "create from factory" do
      setup { Factory :bancomer_payment_info }
      should_change("BancomerPaymentInfo.count", :by => 1) { BancomerPaymentInfo.count }
    end

    context "instance" do
      setup do
        @bancomer_payment_info = Factory(:bancomer_payment_info)
      end

      # these two properties now under control of checkout controller
      # should "not be allowed to be changed when have checkout" do
      # should "not be allowed to be changed when have shippment" do
    end

  end
end

