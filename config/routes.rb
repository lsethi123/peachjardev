Peachjardev::Application.routes.draw do
  get "admin/index"
  post "admin/save_email"
  post "admin/save_template" 
  get "admin/edit_template"
  get "admin/delete_template"
  get "dropbox/list"
  post "dropbox/upload"
  post "dropbox/folder"
  get "dropbox/download"
  get "dropbox/share"
  get "dropbox/logout"
  get "dropbox/destroy"
  get "dropbox/destroy_link"
  match "dropbox/list(/*current_folder)", to:"dropbox#list", :constraints => {:current_folder => /.*/}, via: [:get]
  get "oauth/main"
  get "oauth/auth_start"
  get "oauth/auth_finish"
  post "dropbox/share_with_user"
  root to: "oauth#main"
  devise_for :users
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
