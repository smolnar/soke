Rails.application.routes.draw do
  root to: 'searches#index', as: :search

  resource :search, only: [:index] do
    get :suggest
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    confirmation: 'verification',
    sign_up: 'join'
  }
end
