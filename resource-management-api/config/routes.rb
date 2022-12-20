Rails.application.routes.draw do
  get 'pages/home'
  get 'ping', :to => 'pages#ping'

  namespace :api do
    namespace :v1 do
      get 'profiles/index', to: 'profiles#index'
      post 'profile/create', to: 'profiles#create'
      get 'profile/:id/show', to: 'profiles#show'
      put 'profile/:id/update', to: 'profiles#update'
      patch 'profile/:id/update', to: 'profiles#update'
      delete 'profile/:id/destroy', to: 'profiles#destroy'

      post 'users/register', to: 'users#register'
      post 'users/forget', to: 'users#forget'
    end
  end

  # Defines the root path route ("/")
  root "pages#home"
end
