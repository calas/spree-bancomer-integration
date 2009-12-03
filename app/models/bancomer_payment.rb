class BancomerPayment < Payment
  has_one :info, :class_name => 'BancomerPaymentInfo', :autosave => true, :dependent => :destroy

  before_create :create_info

  validates_presence_of :order_id

  named_scope(:waiting, :include => :info,
              :conditions => "bancomer_payment_infos.response IS NULL AND bancomer_payment_infos.sent_at IS NULL")

  INFO_METHODS = [ :authorization_code, :currency, :error_code,
                   :merchant_code, :notified_at, :received_at, :response,
                   :secure_payment, :transaction_type, :number ]

  INFO_METHODS.each { |d_method| delegate d_method, :to => :info }

  def self.find_by_number(number)
    find(:first, :include => :info, :conditions => ["bancomer_payment_infos.number = ?", number])
  end
end
