Rails.application.routes.draw do
  root "home#index"

  resources :movies do
    collection do
      get :search
    end
  end

  namespace :admin do
    root "static_pages#home"

    resources :users
    resources :movies
  end
end
