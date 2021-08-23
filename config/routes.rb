App::Application.routes.draw do
  root to: 'definities#index'

  resources :definitions, controller: 'definities',
                          path: 'definities',
                          only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    get 'woordvandedag', as: :wotd, on: :collection
    get 'term/:term', as: :term, on: :collection, action: :term
    get 'search', as: :search, on: :collection, action: :search
    get 'begintmet/:prefix', as: :prefix, on: :collection, action: :prefix
    post 'autocomplete', on: :collection, action: :auto_complete_for_definition_q

    get 'random', as: :random, on: :collection, action: :random
    get 'top', as: :top, on: :collection, action: :top
    get 'recent', as: :recent, on: :collection, action: :recent

    get 'wijzigingen', as: :recent_edits, on: :collection, action: :wijzigingen
    get 'reacties', as: :recent_reactions, on: :collection, action: :reacties

    get 'geschiedenis', as: :history, on: :member, action: :history
    post 'thumbsup', on: :member, action: :thumbsup

    # TODO: reactions should really be their own (sub) controller
    post 'reactie', as: :post_reaction, on: :member, action: :add_reaction
    delete 'reactie/:reaction_id', as: :reaction, on: :collection, action: :delete_reactie

    post 'newwotd', as: :new_wotd, on: :member, action: :new_wotd
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

  resources :users, controller: 'gebruiker', id: /.*/, only: [:index] do
    get 'wijzigingen', as: :edits, on: :member, action: :edits
    get 'reacties', as: :reactions, on: :member, action: :reactions
  end
  get '/users/:id' => 'gebruiker#show', as: :user, id: /.*/

  resources :posts, controller: 'post', only: [:index, :new, :create, :show] do
    get 'outbox', as: :outbox, on: :collection, action: :outbox
  end

  get '/recent.xml' => 'definities#recent_rss'
  get '/wijzigingen.xml' => 'definities#wijzigingen_rss', as: :recent_edits_rss
  get '/woordvandedag.xml' => 'definities#woordvandedag'

  get 'robots.txt' => 'utils#robots'
end
