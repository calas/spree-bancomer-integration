CheckoutsHelper.class_eval do
  alias :original_checkout_steps :checkout_steps
  def checkout_steps
    checkout_steps = original_checkout_steps
    checkout_steps.delete("payment")
    checkout_steps
  end
end
