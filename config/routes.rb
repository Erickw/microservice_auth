Rails.application.routes.draw do
  resources :users, only: [:create, :show, :update, :destroy]

  post 'signin', to: 'authentication#signin'
  post 'signup', to: 'authentication#signup'
  post 'reset_password', to: 'users#reset_password'
end
