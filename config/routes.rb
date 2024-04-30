Rails.application.routes.draw do
  resources :forecasts
  root "forecasts#new"
end
