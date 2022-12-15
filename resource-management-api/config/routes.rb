Rails.application.routes.draw do
  get 'pages/home'
  get 'ping', :to => 'pages#ping'

  # Defines the root path route ("/")
  root "pages#home"
end
