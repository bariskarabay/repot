Rails.application.routes.draw do
  resources :orders

  resources :line_items

  resources :carts

  get 'store/index'
  get 'store/deneme'
  resources :products
  root to: 'store#index', as: 'store'
end