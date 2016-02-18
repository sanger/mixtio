Rails.application.routes.draw do

  root 'batches#index'

  resources :consumable_types
  resources :consumables
  resources :batches
  resources :users
  resources :kitchens
  resources :teams
  resources :suppliers

  post 'batches/:id/print', to: 'batches#print', as: 'print'

  post 'favourites/:consumable_type_id', to: 'favourites#create', as: 'favourite'
  delete 'favourites/:consumable_type_id', to: 'favourites#destroy', as: 'unfavourite'

  resources :sessions, only: [:new, :create, :destroy]

  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  namespace :api, defaults: { format: :json } do

    # Redirect to the latest version of the docs... current (and probably forever) v1
    get 'docs', to: redirect('api/v1/docs')

    namespace :v1 do
      get 'docs', to: 'docs#index', defaults: { format: :html }
      resources :consumables, only: [:show, :index]
      resources :consumable_types, only: [:show, :index]
      resources :ingredients, only: [:show, :index]
      resources :batches, only: [:show, :index]
      resources :lots, only: [:show, :index]
      resources :suppliers, only: [:show, :index]
    end
  end

end
