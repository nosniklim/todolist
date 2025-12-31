Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      get 'board', to: 'board#show'
      namespace :lists do
        patch :reorder
      end
    end
  end

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'
  get 'top/index'
  resources :list, only: %i[new create edit update destroy] do
    resources :card, except: %i[index]
  end
  resources :user, only: %i[edit update]
end
