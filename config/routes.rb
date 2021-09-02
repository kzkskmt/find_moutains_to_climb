Rails.application.routes.draw do
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :users, only: %i[new create edit update]
  resources :mountains, only: %i[index show] do
    # resources :courses, only: %i[index show]
  end
  resources :outfits, only: %i[index show]
  root 'homes#top'
  get 'terms_of_use', to: 'homes#terms_of_use'
  get 'privacy_policy', to: 'homes#privacy_policy'
end
