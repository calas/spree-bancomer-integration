Factory.define :bancomer_payment do |p|
  p.association(:order, :factory => :order)
end
