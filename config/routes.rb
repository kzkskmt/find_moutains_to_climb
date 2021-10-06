Rails.application.routes.draw do
  # 開発環境ではメールは送らない。
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resources :users, only: [:index, :show, :new, :create, :edit, :update]
  resources :mountains, only: [:index, :show]
  resources :posts, only: [:new, :create, :edit, :update, :destroy] do
    resources :likes, only: [:create, :destroy]
  end
  resources :outfits, only: [:index, :show]
  resources :password_resets, only: [:new, :create, :edit, :update]
  root 'homes#top'
  get 'terms_of_use', to: 'homes#terms_of_use'
  get 'privacy_policy', to: 'homes#privacy_policy'
end
