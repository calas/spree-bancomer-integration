Factory.define :billing_bancomer, :class => Billing::Bancomer do |b|
  b.name "Bancomer Billing Integration"
  b.preferred_secret_key "mySecretSHA1key"
  b.preferred_merchant_code "1234567"
  b.preferred_terminal 1
  b.preferred_payment_description "Shop at MyStore"
  b.environment ENV['RAILS_ENV']
end
