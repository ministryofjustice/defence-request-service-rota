Rails.application.routes.draw do

  get '/auth/:provider/callback', to: 'sessions#create'

  resources :dashboard, only: [:index]

  root 'dashboards#index'
end
