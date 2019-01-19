Rails.application.routes.draw do
  root "home#index"

  resources :movies do
    collection do
      get :search
      get :json, to: "movies#movies"
    end
  end
end
