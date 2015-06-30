Rails.application.routes.draw do
  devise_for :users, skip: :registrations

  root "dashboards#show"

  resources :location_shifts
  resources :procurement_areas do
    resources :rotas, only: [:index, :new, :create]
  end

  resources :procurement_area_memberships, only: [:new, :create, :destroy]
  resources :shift_requirements, only: [:edit, :update]

  get "/dashboard", to: "dashboards#show", as: :dashboard
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  get "/status" => "status#index"
  get "/ping" => "status#ping"

  namespace :api, format: "json" do
    namespace :v1 do
      resource :on_duty_firm, only: [:show]
    end
  end
end
