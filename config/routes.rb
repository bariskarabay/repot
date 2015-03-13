Rails.application.routes.draw do
  get 'store/index'
  get 'store/deneme'
  resources :products
  root to: 'store#index', as: 'store'
end