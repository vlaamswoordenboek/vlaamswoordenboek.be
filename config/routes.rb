App::Application.routes.draw do
  # TODO: Fix routes.rb

  root to: 'definities#index'

  post '/definities/creeer' => 'definities#creeer'
  post '/definities/update' => 'definities#update'

  resources :definitions, controller: 'definities',
            path: 'definities',
            only: [:show, :new, :create,  :edit, :update] do
    get 'woordvandedag', as: :wotd, on: :collection
    get 'term/:term', as: :term, on: :collection, action: :term
    get 'search', as: :search, on: :collection, action: :search
    get 'begintmet/:prefix', as: :prefix, on: :collection, action: :prefix
    post 'autocomplete', on: :collection, action: :auto_complete_for_definition_q

    get 'random', as: :random, on: :collection, action: :random
    get 'top', as: :top, on: :collection, action: :top
    get 'recent', as: :recent, on: :collection, action: :recent

    get 'geschiedenis', as: :history, on: :member, action: :history

    # TODO: reactions should really be their own (sub) controller
    post 'reactie', as: :post_reaction, on: :member, action: :add_reaction
  end

  resource :info, controller: 'info', only: [:show] do
    get :contact, on: :collection
    get :regios, on: :collection
    get :feeds, on: :collection
    get :updates, on: :collection
  end

  post 'login', controller: :account, as: :login
  get 'login', controller: :account
  get 'logout', controller: :account, as: :logout
  resource :account, controller: 'account', only: [:new, :create, :edit, :update]

  resources :users, controller: 'gebruiker', only: [:index, :show] do
    get 'wijzigingen', as: :edits, on: :member, action: :edits
    get 'reacties', as: :reactions, on: :member, action: :reactions
  end

  # TODO fix wsdl? (was that implemented?)
  # match ':controller/service.wsdl' => '#wsdl'
  get '/definities/term/*id' => 'definities#term'
  get '/:controller(/:action(/:id))'

  get '/recent.xml' => 'definities#recent_rss'
  get '/wijzigingen.xml' => 'definities#wijzigingen_rss'
  get '/woordvandedag.xml' => 'definities#woordvandedag'
end
