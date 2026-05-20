Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/health", to: "health#index"

      resources :users, only: [ :index, :show, :create, :update, :destroy ] do
        resource :settings, controller: "user_settings", only: [ :show, :update ]
      end

      resources :courses, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          post :publish
        end

        collection do
          get :drafts
        end

        resources :enrollments, only: [ :index, :create ]
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
