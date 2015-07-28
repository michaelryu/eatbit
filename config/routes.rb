Rails.application.routes.draw do
  root 'pages#home'
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: :user
  get 'users/:id/texts', to: 'users#texts'
  post 'users/:id/subscribe', to: 'users#subscribe'
  post 'texts/entry', to: 'texts#entry'
  post 'texts/answer', to: 'texts#answer'
  get 'entries', to: 'entries#index'
  get 'entries/all', to: 'entries#all'
  resources :entries
  resource :texts
end
