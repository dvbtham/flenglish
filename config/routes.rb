Rails.application.routes.draw do
  root "home#index"

  devise_for :users, path: "", controllers: {passwords: "passwords"},
    path_names: {sign_in: :login}
  devise_scope :user do
    get :login, to: "devise/sessions#new", as: :new_session
    post :login, to: "devise/sessions#create", as: :session
    delete :logout, to: "devise/sessions#destroy", as: :destroy_session
    get "password/new", to: "devise/passwords#new", as: :new_password
    get "password/edit", to: "devise/passwords#edit", as: :edit_password
    put "password", to: "devise/passwords#update"
    patch "password", to: "devise/passwords#update"
    post "password", to: "passwords#create"
    get "account/cancel", to: "devise/registrations#cancel",
      as: :cancel_registration
    get "singup", to: "devise/registrations#new", as: :new_registration
    get "profile/edit", to: "devise/registrations#edit", as: :edit_registration
    put "profile", to: "devise/registrations#update"
    patch "registration", to: "devise/registrations#update"
    delete "registration", to: "devise/registrations#destroy"
    post "registration", to: "devise/registrations#create"
    get "confirmation/new", to: "devise/confirmations#new",
      as: :new_confirmation
    get "confirmation", to: "devise/confirmations#show"
    post "confirmation", to: "devise/confirmations#create"
  end

  resources :movies do
    collection do
      get :search
      post :search
      get :json, to: "movies#load_movies_to_json"
    end

    member do
      get :watch
    end
  end

  namespace :admin do
    root "static_pages#home"

    resources :users
    resources :movies do
      member{post :subtitles, to: "movies#load_subtitles"}
    end
  end

  resources :vocabularies, :comments, only: %i(create destroy)

  %w(404 422 500 503).each do |code|
    match code, to: "errors#show", code: code, as: "page_" << code, via: :all
  end
end
