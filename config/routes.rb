Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :fetch_user, only: [:show, :index]
  resources :callback, only: :index
  resources :accounts, only: [:index, :show], param: :account
end
