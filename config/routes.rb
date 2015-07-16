Rails.application.routes.draw do
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: :user
  post 'texts/entry', to: 'texts#entry'
  resource :texts
end
