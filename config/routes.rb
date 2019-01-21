Rails.application.routes.draw do
  root "home#index"

  get "/page/404", to: "static_pages#not_found"
  resources :movies do
    collection do
      get :search
      get :json, to: "movies#movies"
    end
  end
end
