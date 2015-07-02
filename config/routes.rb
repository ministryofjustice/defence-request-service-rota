Rails.application.routes.draw do
  devise_for :users, skip: :registrations

  authenticate :user do
    mount Que::Web, at: "que"
  end

  root "dashboards#show"

  resources :location_shifts
  resources :organisations
  resources :procurement_areas do
    resources :rotas, only: [:index, :new, :create]
  end

  resources :procurement_area_memberships, only: [:new, :create, :destroy]
  resources :shift_requirements, only: [:edit, :update]

  get "/dashboard", to: "dashboards#show", as: :dashboard

  get "/status" => "status#index"
  get "/ping" => "status#ping"
end
