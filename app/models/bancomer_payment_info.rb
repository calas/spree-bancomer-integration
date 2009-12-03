class BancomerPaymentInfo < ActiveRecord::Base
  belongs_to :bancomer_payment

  before_save :update_info

  validates_presence_of :bancomer_payment_id

  alias :payment :bancomer_payment

  delegate :order, :to => :payment

  def load_notification(notification)
    update_attributes({ :authorization_code => notification.ds_authorizationcode,
                        :currency           => notification.ds_currency,
                        :error_code         => notification.ds_errorcode,
                        :merchant_code      => notification.ds_merchantcode,
                        :notified_at        => Time.now,
                        :received_at        => notification.received_at,
                        :response           => notification.status,
                        :secure_payment     => notification.ds_securepayment,
                        :transaction_type   => notification.ds_transactiontype })
  end

  private

  def update_info
    return nil unless payment && order
    count = BancomerPayment.count(:conditions => { :order_id => order.id })
    count += 1 if payment.new_record?
    # self.order_amount = order.total
    self.number = (count.to_s + order.number.gsub('R', '')).rjust(12, '0')
  end
end
