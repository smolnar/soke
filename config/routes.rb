Rails.application.routes.draw do
  root to: 'searches#index', as: :search

  resource :search, only: [:index] do
    get :suggest
  end

  resources :results, only: [:show]

  resources :sessions, only: [:index] do
    resources :searches, only: [] do
      get :merge, on: :member
    end
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    confirmation: 'verification',
    sign_up: 'join'
  }

  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
