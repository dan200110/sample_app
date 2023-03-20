Rails.application.routes.draw do
  get 'controllername/new'
  get 'controllername/create'
  scope "(:locale)", locale: /en|vi/ do
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end

  concern :api_base do
    resources :users
    resources :microposts
  end

  scope module: "api", path: "api" do
    scope module: "v1", path: "v1" do
      post "/login", to: "auth#create"
      resources :microposts
      resources :branches
      resources :employees
      resources :categories
      resources :suppliers
      resources :batch_inventories do
        get :get_all_expired, on: :collection
      end
      resources :inventories do
        get :get_expired, on: :collection
        get :get_out_of_stock, on: :collection
        get :send_request_mail_to_supplier, on: :collection
      end
      resources :statistic do
        get :get_total_order_price, on: :collection
        get :get_order_by_day, on: :collection
        get :get_revenue_order, on: :collection
        get :get_total_import_inventory_price, on: :collection
      end
      resources :ledger
      resources :import_inventories
      resources :orders
      resources :export_csv do
        get :export_employee, on: :collection
        get :export_inventory, on: :collection
      end
      scope module: "ad", path: "ad" do
        post "/login", to: "auth#create"
        resources :admins
        resources :branches
        resources :employees
        resources :categories
        resources :suppliers
        resources :inventories do
          get :get_expired, on: :collection
          get :get_out_of_stock, on: :collection
          get :send_request_mail_to_supplier, on: :collection
        end
        resources :statistic
        resources :ledger
        resources :import_inventories
        resources :orders
        resources :export_csv do
          get :export_employee, on: :collection
          get :export_inventory, on: :collection
        end
      end
    end
  end

end
