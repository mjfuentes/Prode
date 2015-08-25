Rails.application.routes.draw do
  resources :matchdays
  resources :matches
  resources :guesses
  # ROOT 
  root 'main#welcome'

  # POST METHODS
  post 'players/new'
  post 'login' => 'main#login'  
  post 'match' => 'matches#create'
  post 'game/play' => 'game#save'

  # GET METHODS
  get 'home' => 'main#home'
  get 'login' => 'main#login_form'
  get 'register_form' => 'main#register'
  get 'logout' => 'main#logout'
  get 'matches/new'
  get 'matches/new/:id' => 'matches#new'
  get 'matchdays/:id/start' => 'matchdays#start'
  get 'matchdays/:id/end' => 'matchdays#end'
  get 'game/play'
  get 'game/history' 
  get 'game/show/:id' => 'game#show'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
