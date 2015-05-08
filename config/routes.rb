Rails.application.routes.draw do
  root "dashboards#show"

  resources :location_shifts
  resources :procurement_areas
  resources :procurement_area_locations, only: [:new, :create, :destroy]
  resources :procurement_area_memberships, only: [:new, :create, :destroy]
  resources :shift_requirements, only: [:edit, :update]

  get "/dashboard", to: "dashboards#show", as: :dashboard
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
end
