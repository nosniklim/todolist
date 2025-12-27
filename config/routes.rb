Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'
  get 'top/index'
  resources :list, only: %i[new create edit update destroy] do
    resources :card, except: %i[index]
  end
  resources :user, only: %i[edit update]
end
