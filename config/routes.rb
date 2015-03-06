Rails.application.routes.draw do
  root to: 'searches#index', as: :search

  resource :search, only: [:index] do
    get :suggest
  end
end
