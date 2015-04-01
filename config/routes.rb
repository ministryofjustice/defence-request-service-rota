Rails.application.routes.draw do
  root "dashboards#show"

  resource :dashboard, only: [:show]

  get "/auth/:provider/callback", to: "sessions#create"
end
