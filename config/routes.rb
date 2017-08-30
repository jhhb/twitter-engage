Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'resque/server'

  root 'pages#welcome'
  get 'pages/about' => 'pages#about', as: :about
  get 'pages/contact' => 'pages#contact', as: :contact

  get 'dashboards/get_tweets' => 'dashboards#get_tweets', as: :get_tweets
  post 'dashboards/set_keywords' => 'dashboards#set_keywords', as: :set_keywords
  get 'dashboards/show_user_dashboard' => 'dashboards#show_user_dashboard', as: :show_user_dashboard

  mount Resque::Server.new, at: "/resque"
  mount Sidekiq::Web => "/sidekiq"

  get 'tables/filter/:number_of_results' => 'tables#filter', as: :filter
  get 'tables/filter/:number_of_results/paginate/:page_number' => 'tables#filter', as: :paginate
  resources :tables

  post 'tweets/save' => 'tweets#save', as: :tweet
  resources :tweets

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
