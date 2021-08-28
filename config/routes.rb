Rails.application.routes.draw do
  resources :mountains, only: %i[index show] do
    # resources :courses, only: %i[index show]
  end
  resources :outfits, only: %i[index show edit update]
  root 'homes#top'
  get 'terms_of_use', to: 'homes#terms_of_use'
  get 'privacy_policy', to: 'homes#privacy_policy'
end
