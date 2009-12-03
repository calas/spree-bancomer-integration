class CreateBancomerPaymentInfos < ActiveRecord::Migration
  def self.up
    create_table :bancomer_payment_infos do |t|
      t.integer   :bancomer_payment_id
      t.string    :authorization_code
      t.string    :merchant_code
      t.string    :number
      t.string    :response
      t.integer   :currency
      t.boolean   :secure_payment
      t.string    :transaction_type
      t.datetime  :sent_at
      t.datetime  :received_at
      t.datetime  :notified_at
      t.string    :error_code

      t.timestamps
    end
  end

  def self.down
    drop_table :bancomer_payment_infos
  end
end
