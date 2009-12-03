Order.class_eval do
  has_many :bancomer_payments, :dependent => :destroy

  def payment_number
    waiting_payment.number
  end

  def waiting_payment
    payment = bancomer_payments.waiting.first
    payment = bancomer_payments.create! unless payment
    payment
  end
end
