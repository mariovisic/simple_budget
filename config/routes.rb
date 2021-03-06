Rails.application.routes.draw do
  root 'dashboard#index'

  resources :budgets, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :transactions, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :transfers, only: [ :new, :create ]
  resources :graphs, only: [ :index ]

  resource :session, only: [ :new, :create ]
end
