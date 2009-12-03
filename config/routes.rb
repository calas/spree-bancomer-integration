map.resource :bancomer_notification, :controller => 'bancomer_notification', :only => [:create]

map.resources :orders do |order|
  order.resource :checkout, :member => { :bancomer => :get, :bancomer_ok => :any, :bancomer_ko => :any }
end
