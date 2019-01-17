Rails.application.routes.draw do
  root "home#index"

  get "/movies/:id", to: "movies#show", as: "movies_detail"
  get "/search", to: "movies#search", as: "search_movies"
end
