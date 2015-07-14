Rails.application.routes.draw do
  get 'texts/create', to: 'texts#create'
  post 'texts/create', to: 'texts#create'
  resource :text, only: :create
end
