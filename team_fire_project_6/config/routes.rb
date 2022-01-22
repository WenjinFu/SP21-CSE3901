
Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#home'
  get  '/login',    to: 'static_pages#login'
  get  '/signup',   to: 'users#new'
  resources :users
end
