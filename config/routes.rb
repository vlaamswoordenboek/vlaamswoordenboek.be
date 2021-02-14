ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '/definities/term/*id', :controller=>'definities', :action=>'term'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
  map.connect '/recent.xml', :controller => 'definities', :action => 'recent_rss'
  map.connect '/wijzigingen.xml', :controller => 'definities', :action => 'wijzigingen_rss'
  map.connect '/woordvandedag.xml', :controller => 'definities', :action => 'woordvandedag_rss'
  
  # Catch all
  map.connect "*anything", :controller => "definities", :action => 'index'
end
