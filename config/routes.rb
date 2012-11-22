Gandalf::Application.routes.draw do
  
  root :to => "events#index"
  
  match '/login' => "main#login"
  match '/logout' => "main#logout"
  match '/welcome' => "main#welcome"
  
  match '/me' => "users#me"
  match '/users/:id/events' => 'users#events'
  match '/users/:id/subscribed_organizations' => 'users#subscribed_organizations'
  match '/users/:id/subscribed_categories' => 'users#subscribed_categories'
  
  match '/events' => 'events#all'
  
  match '/organizations' => 'organizations#all'
  
  match '/categories' => 'categories#all'
end
