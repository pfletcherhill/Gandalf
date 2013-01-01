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
  match '/users/:id/follow/organization/:organization_id' => 'users#follow_organization'
  match '/users/:id/unfollow/organization/:organization_id' => 'users#unfollow_organization'
  
  match '/events' => 'events#all'
  match '/events/create' => 'events#create'
  
  resources :organizations
  match '/organizations/:id/add_image' => 'organizations#add_image'
  match '/organizations/:id/events' => 'organizations#events'
  match '/organizations/:id/subscribed_users' => 'organizations#subscribed_users'
  
  match '/categories' => 'categories#all'
  
  #Search
  match '/search/organizations/:query' => 'organizations#search'
  match '/search/events/:query' => 'events#search'
  match '/search/categories/:query' => 'categories#search'
  match '/search/all/:query' => 'main#search_all'
  
end
