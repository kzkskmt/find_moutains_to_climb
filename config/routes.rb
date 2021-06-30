Rails.application.routes.draw do
  resources :mountains, only: %i[index show]
  root 'homes#top'
end
