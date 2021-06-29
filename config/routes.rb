Rails.application.routes.draw do
  resources :mountains, only: %i[index show]
end
