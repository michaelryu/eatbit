Rails.application.routes.draw do

  root 'pages#home'
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: :user
  post 'texts/entry', to: 'texts#entry'
  post 'texts/answer', to: 'texts#answer'
  get 'entries', to: "entries#index"
  resources :entries
  resource :texts
end
