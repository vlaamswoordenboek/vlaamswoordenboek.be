App::Application.routes.draw do
  # TODO: Fix routes.rb

  root to: 'definities#index'

  post '/definities/creeer' => 'definities#creeer'
  post '/definities/update' => 'definities#update'

  match ':controller/service.wsdl' => '#wsdl'
  match '/definities/term/*id' => 'definities#term'
  match '/:controller(/:action(/:id))'
  match '/recent.xml' => 'definities#recent_rss'
  match '/wijzigingen.xml' => 'definities#wijzigingen_rss'
  match '/woordvandedag.xml' => 'definities#woordvandedag_rss'
  match '*anything' => 'definities#index'
end
