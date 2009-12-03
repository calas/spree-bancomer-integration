class BancomerNotificationController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  before_filter :check_integration, :only => :create
  before_filter :check_acknowledge, :only => :create
  before_filter :find_payment, :only => :create

  def create
    @order = @payment.order
    render :nothing => true
  end

  private

  def check_integration
    @integration = Billing::Bancomer.current
    ignore_request unless @integration
  end

  def check_acknowledge
    @notification = @integration.notification(request.raw_post)
    ignore_request unless @notification.acknowledge
  end

  def find_payment
    @payment = BancomerPayment.find_by_number(@notification.item_id)
    ignore_request and return unless @payment
    @payment.amount = @notification.gross
    @payment.info.load_notification(@notification)
    @payment.save
  end

  def ignore_request
    render :nothing => true, :status => :not_found
  end
end
