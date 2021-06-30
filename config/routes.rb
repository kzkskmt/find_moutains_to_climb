Rails.application.routes.draw do
  get 'homes/top'
  resources :mountains, only: %i[index show]
end
