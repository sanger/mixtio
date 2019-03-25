Rails.application.routes.draw do

  root 'batches#index'


  get 'consumable_types/archive', to: 'consumable_types#archive_index', as: 'consumable_types_archive'
  resources :consumable_types
  resources :consumables
  resources :batches
  resources :users
  resources :kitchens
  resources :teams
  get 'suppliers/archive', to: 'suppliers#archive_index', as: 'suppliers_archive'
  resources :suppliers
  get 'projects/archive', to: 'projects#archive_index', as: 'projects_archive'
  resources :projects

  put 'consumable_types/:id/deactivate', to: 'consumable_types#deactivate', as: 'deactivate_consumable_type'
  put 'consumable_types/:id/activate', to: 'consumable_types#activate', as: 'activate_consumable_type'

  put 'suppliers/:id/deactivate', to: 'suppliers#deactivate', as: 'deactivate_supplier'
  put 'suppliers/:id/activate', to: 'suppliers#activate', as: 'activate_supplier'

  put 'projects/:id/deactivate', to: 'projects#deactivate', as: 'deactivate_project'
  put 'projects/:id/activate', to: 'projects#activate', as: 'activate_project'

  post 'batches/:id/print', to: 'batches#print', as: 'print'
  get 'batches/:id/support', to: 'batches#support', as: 'support'

  post 'favourites/:consumable_type_id', to: 'favourites#create', as: 'favourite'
  delete 'favourites/:consumable_type_id', to: 'favourites#destroy', as: 'unfavourite'

  resources :sessions, only: [:new, :create, :destroy]

  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  namespace :api, defaults: { format: :json } do

    # Redirect to the latest version of the docs... current (and probably forever) v1
    get 'docs', to: redirect('api/v2/docs')

    namespace :v1 do
      get 'docs', to: 'docs#index', defaults: { format: :html }
      resources :consumables, only: [:show, :index]
      resources :consumable_types, only: [:show, :index]
      resources :ingredients, only: [:show, :index]
      resources :batches, only: [:show, :index]
      resources :lots, only: [:show, :index]
      resources :suppliers, only: [:show, :index]
      resources :projects, only: [:show, :index]
    end

    namespace :v2 do
      get 'docs', to: 'docs#index', defaults: { format: :html }
      resources :consumables, only: [:show, :index]
      resources :consumable_types, only: [:show, :index]
      resources :ingredients, only: [:show, :index]
      resources :batches, only: [:show, :index]
      resources :lots, only: [:show, :index]
      resources :suppliers, only: [:show, :index]
      resources :projects, only: [:show, :index]
    end
  end

  match 'test_exception_notifier', controller: 'application', action: 'test_exception_notifier', via: :get

end
