Rails.application.routes.draw do
  root "home#index"

  resources :movies do
    collection do
      get :search
      get :json, to: "movies#load_movies_to_json"
    end

    member do
      get :watch
    end
  end

  namespace :admin do
    root "static_pages#home"

    resources :users
    resources :movies
  end

  %w(404 422 500 503).each do |code|
    match code, to: "errors#show", code: code, as: "page_" << code, via: :all
  end
end
