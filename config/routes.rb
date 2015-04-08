Rails.application.routes.draw do
  root "dashboards#show"

  get "/dashboard", to: "dashboards#show", as: :dashboard

  get "/auth/:provider/callback", to: "sessions#create"
end
