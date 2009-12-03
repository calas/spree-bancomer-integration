class Billing::Bancomer < BillingIntegration
  preference :merchant_code, :string
  preference :secret_key, :string
  preference :terminal, :integer, :default => 1
  preference :payment_description, :string

  Integration = ActiveMerchant::Billing::Integrations::Bancomer

  def notification(raw_post)
    Integration::Notification.new(raw_post, :sha1secret => preferred_secret_key)
  end

  def get_helper(order)
    bm_helper = Integration::Helper.new(order.payment_number, preferred_merchant_code, :amount => order.total)
    bm_helper.sha1secret   preferred_secret_key
    bm_helper.description  preferred_payment_description
    bm_helper.terminal     preferred_terminal
    bm_helper.customer     order.bill_address.try(:full_name)
    return bm_helper
  end

end
