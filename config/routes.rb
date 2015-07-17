Rails.application.routes.draw do
  root 'pages#home'
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: :user
  post 'texts/entry', to: 'texts#entry'
  resource :texts
end
