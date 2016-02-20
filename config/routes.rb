Rails.application.routes.draw do
  root 'budgets#index'

  resources :budgets, only: [ :index, :new, :create ]
end
