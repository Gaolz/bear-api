Rails.application.routes.draw do
  namespace :api do
    post "login", to: "sessions#create"
    get "me", to: "users#me"
    resources :runs, only: [:index, :create, :update, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
