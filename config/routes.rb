App::Application.routes.draw do
  # TODO: Fix routes.rb

  root to: 'definities#index'

  post '/definities/creeer' => 'definities#creeer'
  post '/definities/update' => 'definities#update'

  # TODO fix wsdl? (was that implemented?)
  # match ':controller/service.wsdl' => '#wsdl'
  get '/definities/term/*id' => 'definities#term'
  get '/:controller(/:action(/:id))'
  get '/recent.xml' => 'definities#recent_rss'
  get '/wijzigingen.xml' => 'definities#wijzigingen_rss'
  get '/woordvandedag.xml' => 'definities#woordvandedag_rss'
  get '*anything' => 'definities#index'
end
