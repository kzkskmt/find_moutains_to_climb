Rails.application.routes.draw do
  resources :mountains, only: %i[index show] do
    resource :course, only: %i[show]
  end
  root 'homes#top'
end
