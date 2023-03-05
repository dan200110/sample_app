Rails.application.routes.draw do
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
      resources :employees
    end
  end

end
