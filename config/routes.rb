Gandalf::Application.routes.draw do
  
  root :to => "events#root"
  
  match '/login' => "main#login"
  match '/logout' => "main#logout"
  match '/welcome' => "main#welcome"
  
  match '/me' => "users#me"
  match '/mail' => "users#mail"
  match '/users/:id/events' => 'users#events'
  match '/users/:id/organizations' => 'users#organizations'
  match '/users/:id/subscribed_organizations' => 'users#subscribed_organizations'
  match '/users/:id/subscribed_categories' => 'users#subscribed_categories'
  match '/users/:id/subscriptions' => 'users#subscriptions'
  match '/users/:id/follow/organization/:organization_id' => 'users#follow_organization'
  match '/users/:id/unfollow/organization/:organization_id' => 'users#unfollow_organization'
  match '/users/:id/follow/category/:category_id' => 'users#follow_category'
  match '/users/:id/unfollow/category/:category_id' => 'users#unfollow_category'
  
  resources :events
  
  resources :organizations
  match '/organizations/:id/add_image' => 'organizations#add_image'
  match '/organizations/:id/events' => 'organizations#events'
  match '/organizations/:id/subscribed_users' => 'organizations#subscribed_users'
  
  match '/categories' => 'categories#all'
  match '/categories/:id/events' => 'categories#events'
  match '/categories/:id' => 'categories#show'
  
  #Search
  match '/search/organizations/:query' => 'organizations#search'
  match '/search/events/:query' => 'events#search'
  match '/search/categories/:query' => 'categories#search'
  match '/search/all/:query' => 'main#search_all'
  
end
