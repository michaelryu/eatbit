Rails.application.routes.draw do
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: :user

  post 'texts/create', to: 'texts#create'
  resource :texts
end
