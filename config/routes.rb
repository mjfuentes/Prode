Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'  }
  resources :teams
  resources :matchdays
  resources :matches
  resources :guesses
  # ROOT 
  root 'main#home'
  # POST METHODS
  post 'match' => 'matches#create'
  post 'game/play' => 'game#save'

  # GET METHODS
  get 'home' => 'main#home'
  get 'restart' => 'main#restart'
  get 'matches/new/:id' => 'matches#new', :as => :matches_new
  get 'matchdays/:id/start' => 'matchdays#start', :as => :start_matchday
  get 'matchdays/:id/end' => 'matchdays#end', :as => :end_matchday
  get 'matchdays/:id/simulate' => 'matchdays#simulate_results', :as => :simulate_results
  get 'game/play'
  get 'game/history' 
  get 'game/show/:id' => 'game#show'
  get 'game/ranking'
  get 'game/simulate' => 'game#simulate'

  # #FACEBOOK
  # get 'auth/:provider/callback' => 'main#facebook'
  # get 'auth/failure' => redirect('/')

end
