Rails.application.routes.draw do
  root "dashboards#show"

  resources :procurement_areas, except: [:show]

  get "/dashboard", to: "dashboards#show", as: :dashboard

  get "/auth/:provider/callback", to: "sessions#create"
end
