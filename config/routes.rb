Rails.application.routes.draw do
  root 'dashboard#index'

  resources :budgets, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :transactions, only: [ :index, :new, :create, :edit, :update, :destroy ]
end
