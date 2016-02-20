Rails.application.routes.draw do
  root to: redirect('transactions')

  resources :budgets, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :transactions, only: [ :index, :new, :create ]
end
