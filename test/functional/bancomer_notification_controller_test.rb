require File.join(File.dirname(__FILE__), '/../test_helper')

class BancomerNotificationControllerTest < ActionController::TestCase
  context BancomerNotificationController do
    should_route :post, '/bancomer_notification', :controller => :bancomer_notification, :action => :create
    context "without Bancomer Billing Integration configured" do
      setup { post :create }
      should_respond_with :not_found
    end

    context "with Bancomer Billing Integration configured" do
      setup { @billing = Factory.create(:billing_bancomer) }

      context "default responses" do
        setup { @notification = BancomerTest::Notification.new(:billing => @billing) }
        context "forged request" do
          setup { post :create, @notification.default_params }
          should_respond_with :not_found
        end

        context "authenticated request" do
          setup { post :create, @notification.valid_payment }
          should_respond_with :success
          should_not_set_the_flash
          should_assign_to :notification, :payment, :order

          should "assign a correct order" do
            assert_equal @notification.order, assigns(:order)
          end

          should "set payment information" do
            payment = assigns(:payment)
            assert_equal (@notification.ds_amount.to_i / 100.0), payment.amount
            assert_equal @notification.ds_response, payment.response
            assert_equal @notification.received_at, payment.received_at
          end

          should "mark order as completed" do

          end
        end
      end
    end
  end
end

