Rails.application.routes.draw do
  root to: 'search#index'

  resource :search
end
