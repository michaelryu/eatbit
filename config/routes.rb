Rails.application.routes.draw do
  post 'texts/create', to: 'texts#create'
  get 'texts', to: 'texts#index'
  resource :texts
end
