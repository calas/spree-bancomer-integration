Factory.define :bancomer_payment_info do |p|
  p.association(:bancomer_payment, :factory => :bancomer_payment)
end
