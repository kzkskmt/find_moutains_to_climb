Rails.application.routes.draw do
  resources :mountains, only: %i[index show] do
    resources :courses, only: %i[index show]
    collection do
      get 'search'
    end
  end
  resources :outfits, only: %i[index show create new edit update]
  root 'homes#top'
end
