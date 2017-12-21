Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'instas#index'

  get 'instas/new'
  post 'instas/create'
  post 'instas/destroy/:id' => 'instas#destroy'
  get 'instas/edit/:id' => 'instas#edit'
  get 'instas/show/:id' => 'instas#show'
  post 'instas/update/:id' => 'instas#update'
  get 'instas/add_comment/:id' => 'instas#add_comment'
  get 'users/signup'
  get 'users/register'
  get 'users/login'
  get 'users/login_session'
  get 'users/logout'

  # resources: belongs # 이놈을 입력하고 3000/rails/info/routes에서 확인하면
  # 이런식으로 url이 나옴 ! url을 규칙성 있게 만들고 구분을 지어준다 !
  # belong_path	GET	/belongs/:id(.:format)	belongs#show
  #             PATCH	/belongs/:id(.:format)	belongs#update
  #             PUT	/belongs/:id(.:format)	belongs#update
  #             DELETE	/belongs/:id(.:format)	belongs#destroy
  # restful의 정의
  # 진짜 사람이 말하는 것처럼 url 을 바꾸면 안될까? 그럼 바꿔보자 !
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
