Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => redirect("http://www.eatbit.co/")
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: :user
  get 'users/:id/texts', to: 'users#texts'
  get 'users/:id/unsubscribe', to: 'users#unsubscribe'
  post 'users/:id/subscribe', to: 'users#subscribe'
  get 'users/:id/log', to: 'users#log'
  post 'texts/entry', to: 'texts#entry'
  post 'texts/answer', to: 'texts#answer'
  get 'entries', to: 'entries#index'
  get 'entries/all', to: 'entries#all'
  resources :entries
  resource :texts
end
