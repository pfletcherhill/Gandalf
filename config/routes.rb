Gandalf::Application.routes.draw do

  root :to => "main#root"
  
  match '/login' => "main#login"
  match '/logout' => "main#logout"
  match '/welcome' => "main#welcome"
  
  match '/me' => "users#me", via: [:get, :post]
  match '/me' => "users#update", via: [:put]
  match '/mail' => "users#mail"
  match '/users/events' => 'users#events'
  match '/users/organizations' => 'users#organizations'
  match '/users/subscribed_organizations' => 'users#subscribed_organizations'
  match '/users/subscribed_categories' => 'users#subscribed_categories'
  match '/users/subscriptions' => 'users#subscriptions'
  match '/users/follow/organization/:organization_id' => 'users#follow_organization'
  match '/users/unfollow/organization/:organization_id' => 'users#unfollow_organization'
  match '/users/follow/category/:category_id' => 'users#follow_category'
  match '/users/unfollow/category/:category_id' => 'users#unfollow_category'
  match '/users/bulletin_preference' => "users#bulletin_preference"

  # For testing
  match '/bulletin' => "users#bulletin"
  
  resources :events
  
  resources :organizations
  match '/organizations/slug/:slug' => 'organizations#show_by_slug', via: [:get]
  match '/organizations/:id/add_image' => 'organizations#add_image'
  match '/organizations/:id/events' => 'organizations#events'
  match '/organizations/:id/subscribed_users' => 'organizations#subscribed_users'
  match '/organizations/:id/admins' => 'organizations#admins'
  match '/organizations/:id/email' => 'organizations#subscriber_email'
  
  match '/categories' => 'categories#all'
  match '/categories/:id/events' => 'categories#events'
  match '/categories/slug/:slug' => 'categories#show_by_slug', via: [:get]
  match '/categories/:id' => 'categories#show'
  
  #Search
  match '/search/organizations/:query' => 'organizations#search'
  match '/search/events/:query' => 'events#search'
  match '/search/categories/:query' => 'categories#search'
  match '/search/location/:query' => 'location#search'
  match '/search/all/:query' => 'main#search_all'
  
end
