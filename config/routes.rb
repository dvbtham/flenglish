Rails.application.routes.draw do
  root "home#index"

  resources :movies do
    collection do
      get :search
    end
  end
end
