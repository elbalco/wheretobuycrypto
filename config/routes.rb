Rails.application.routes.draw do
  resources :coins, only: [:index, :show]

  root to: 'static#index'
end
