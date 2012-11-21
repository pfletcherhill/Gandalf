Gandalf::Application.routes.draw do
  
  root :to => "events#index"
  
  match '/login' => "main#login"
  match '/logout' => "main#logout"
  match '/welcome' => "main#welcome"
  
  match '/me' => "users#me"
  match '/users/:id/events' => 'users#events'
  
  match '/events' => 'events#all'
end
