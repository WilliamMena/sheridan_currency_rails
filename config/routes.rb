Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  post '/create', to: 'home#create'
  get '/show', to: 'home#show'
end
