unless defined? SPREE_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["SPREE_ENV_FILE"]
    require ENV["SPREE_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/SPREE/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end
require "#{SPREE_ROOT}/test/test_helper"

Dir[File.join(File.dirname(__FILE__), 'factories/*.rb')].each do |factory|
  require factory
end

puts "loading bancomer_integration tests"

module BancomerTest
  class Notification

    attr_accessor :billing, :order, :params, :received_at

    def initialize(opts={ })
      @billing = opts.delete(:billing) || Billing::Bancomer.current || Factory(:billing_bancomer)
      @order = opts.delete(:order) || create_complete_order
      @params = default_params.merge(opts)
      set_date
    end

    def set_date(date=Time.now)
      @params.merge!({ "Ds_Date" => date.strftime('%d/%m/%Y'),
                       "Ds_Hour" => date.strftime('%H:%M')})
      @received_at = DateTime.strptime("#{ds_date} #{ds_hour}", "%d/%m/%Y %H:%M")
    end

    def default_params
      {
        "Ds_Amount" => (order.total * 100).to_i,
        "Ds_ConsumerLanguage" => "1",
        "Ds_Currency" => "484",
        "Ds_MerchantCode" => "7654321",
        "Ds_Order" => order.payment_number,
        "Ds_SecurePayment" => "0",
        "Ds_Terminal" => "001",
        "Ds_TrasactionType" => "0"
      }
    end

    def invalid_payment
      @params.merge!({"Ds_AuthorisationCode" => "      ",
                       "Ds_ErrorCode" => "SIS0051",
                       "Ds_Response" => "SIS0051" })
      sign!
    end

    def valid_payment
      @params.merge!({ "Ds_AuthorisationCode" => "123456",
                       "Ds_Response" => "000",
                       "Ds_ErrorCode" => nil })
      sign!
    end

    def sign!
      @params.merge!('Ds_Signature' => Digest::SHA1.hexdigest(generate_sha1string))
    end

    def method_missing(method_sym, *args)
      if method_sym.to_s =~ /^(ds)_([a-z_]+)$/
        @params["#{$1.capitalize}_#{$2.classify}"]
      else
        super
      end
    end

    private

    def generate_sha1string
      [ 'Ds_Amount', 'Ds_Order', 'Ds_MerchantCode',
        'Ds_Currency', 'Ds_Response' ].map { |key| @params[key.to_s] } * "" + billing.preferred_secret_key
    end

    # def forged_post_data
    #   @params.map { |k,v| "#{k}=#{v}"}.join('&')
    # end
  end
end
