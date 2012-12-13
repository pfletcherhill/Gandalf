Gandalf::Application.routes.draw do
  
  root :to => "events#index"
  
  match '/login' => "main#login"
  match '/logout' => "main#logout"
  match '/welcome' => "main#welcome"
  
  match '/me' => "users#me"
  match '/users/:id/events' => 'users#events'
  match '/users/:id/organizations' => 'users#organizations'
  match '/users/:id/subscribed_organizations' => 'users#subscribed_organizations'
  match '/users/:id/subscribed_categories' => 'users#subscribed_categories'
  
  match '/events' => 'events#all'
  
  resources :organizations
  match '/organizations/:id/add_image' => 'organizations#add_image'
  match '/organizations/:id/events' => 'organizations#events'
  
  match '/categories' => 'categories#all'
end
