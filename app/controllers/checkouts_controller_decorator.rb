CheckoutsController.class_eval do
  ssl_required :update, :edit, :bancomer

  skip_before_filter :verify_authenticity_token, :only => [:bancomer_ko, :bancomer_ok]
  before_filter :load_bancomer_data, :only => [:bancomer_ok, :bancomer_ko]

  def bancomer_ok
    render
  end

  def bancomer_ko
    flash[:error] = "Error en el pago. Su orden no ha sido procesada."
    redirect_to edit_object_url
  end

  def bancomer
    if integration = Billing::Bancomer.current
      load_object
      bm_helper = integration.get_helper(@order)
      bm_helper.notify_url        bancomer_notification_url
      bm_helper.return_url        bancomer_ok_order_checkout_url(@order)
      bm_helper.cancel_return_url bancomer_ko_order_checkout_url(@order)

      render :partial => 'shared/bancomer_form', :locals => { :bancomer_helper => bm_helper }
    else
      render :nothing => true
    end
  end

  private

  def load_bancomer_data
    load_object
    @post_data = request.raw_post
  end
end
