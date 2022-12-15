Rails.application.routes.draw do
  get 'pages/home'
  get 'ping', :to => 'pages#ping'

  namespace :api do
    namespace :v1 do
      post 'users/register', :to => 'users#register'
      post 'users/forget', :to => 'users#forget'
    end
  end

  # Defines the root path route ("/")
  root "pages#home"
end
