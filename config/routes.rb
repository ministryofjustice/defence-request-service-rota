Rails.application.routes.draw do
  root "dashboards#show"

  resources :location_shifts
  resources :procurement_areas
  resources :procurement_area_memberships, only: [:new, :create, :destroy]
  resources :procurement_area_rotas, only: [:index, :new, :create]
  resources :shift_requirements, only: [:edit, :update]

  get "/dashboard", to: "dashboards#show", as: :dashboard
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  get "/status" => "status#index"
  get "/ping" => "status#ping"

  scope module: :api, defaults: { format: "json" } do
    namespace :v1 do
      resource :on_duty_firm, only: [:show]
    end
  end
end
