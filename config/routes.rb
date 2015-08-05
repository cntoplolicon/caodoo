Rails.application.routes.draw do
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

  root 'products#index'
  resources :products

  resources :users do
    resources :orders do
      get :payment
      get :payment_timeout
      get :payment_succeed
      get :status
      get :express_info
    end
    resources :addresses

    collection do
      get :login
      post :do_login
      get :logout
      get :forget_password
      get :reset_password_done
      post :reset_password
      get :terms_of_service
      post :get_security_code_for_new_user
      post :get_security_code_for_password
    end

    member do
      get :user_settings
    end
  end

  get :about_us, to: 'standalone#about_us'
  get :custom_service, to: 'standalone#custom_service'
  get :sold_out, to: 'standalone#sold_out'

  get '/provinces/:province_code/cities', to: 'regions#get_cities_in_province'
  get '/cities/:city_code/districts', to: 'regions#get_districts_in_city'

  post 'alipay/pay', to: 'alipay#pay'
  get 'alipay/return', to: 'alipay#sync_notify'
  post 'alipay/notify', to: 'alipay#async_notify'

  post 'wx_pay/pay', to: 'wx_pay#pay'
  post 'wx_pay/pay_by_jsapi', to: 'wx_pay#pay_by_jsapi'
  post 'wx_pay/notify', to: 'wx_pay#notify'

  resources :contest_teams do
    collection do
      get :login
      post :do_login
      get :logout
    end
    member do
      get :contest_product_links
      get :notification
    end
    resources :refund_records
    resources :contest_products
  end

  resources :contest_products

  get 'qccy/login', to: 'contest_teams#login'

  namespace :admin do
    root 'orders#index'
    resources :products do
      resource :product_carousel_images
      resource :product_detail_images
      resource :product_homepage_images
      resources :product_sale_schedules
    end
    resources :brands
    resources :contest_teams do
      member do
        get :reset_password
        post :do_reset_password
      end
    end
    resources :refund_records do
      member do
        get :express_info
      end
    end
    resources :regions
    resources :expresses
    resources :orders do
      collection do
        get :upload_delivery
        post :import_delivery
        get :upload_payment
        post :import_payment
      end
      member do
        get :express_info
      end
    end
  end

  namespace :customer_service do
    root 'orders#index'
    resources :orders
    resources :refund_records
  end

  get 'access_token', to: 'wx_test#access_token'
  get 'jsapi_ticket', to: 'wx_test#jsapi_ticket'

  get 'orders/payment/:order_id', to: 'orders#payment', as: 'orders_payment'
end
