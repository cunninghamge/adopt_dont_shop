Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"

  get "/shelters", to: "shelters#index"
  get "/shelters/new", to: "shelters#new"
  post "/shelters", to: "shelters#create"
  get "/shelters/:id", to: "shelters#show"
  get "/shelters/:id/edit", to: "shelters#edit"
  patch "/shelters/:id", to: "shelters#update"
  delete "/shelters/:id", to: "shelters#destroy"

  get "/pets", to: "pets#index"
  get "/pets/:id", to: "pets#show", as: :pet
  get "/pets/:id/edit", to: "pets#edit"
  patch "/pets/:id", to: "pets#update"
  delete "/pets/:id", to: "pets#destroy"

  get "/shelters/:shelter_id/pets", to: "shelter_pets#index"
  get "/shelters/:shelter_id/pets/new", to: "shelter_pets#new"
  post "/shelters/:shelter_id/pets", to: "shelter_pets#create"
  get "/shelters/:id/pets/:id", to: "pets#show"

  get '/applications/new', to: "applications#new"
  post '/applications/:id/pets', to: 'application_pets#create', as: :application_pets
  post '/applications', to: 'applications#create'
  get '/applications/:id', to: 'applications#show', as: :application
  patch '/applications/:id', to: 'applications#update'

  namespace :admin do
    get '/applications/:id', to: 'applications#show'
    patch '/applications/:id', to: 'applications#update'
  end
end
