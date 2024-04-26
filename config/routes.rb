Rails.application.routes.draw do
  # TODO: Make sure I need all of these
  resources :forecasts
  root "home#index"
end
