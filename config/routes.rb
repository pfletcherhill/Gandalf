Gandalf::Application.routes.draw do

  root :to => "main#root"
  
  get '/login' => "main#login"
  get '/logout' => "main#logout"
  get '/welcome' => "main#welcome"
  
  get '/admin' => "admin#index"
  get '/admin/events' => "admin#events"
  get '/admin/organizations' => "admin#organizations"
  get '/admin/users' => "admin#users"
  get '/admin/categories' => "admin#categories"
  get '/admin/locations' => "admin#locations"
  get '/admin/organizations/import' => 'admin#import_organizations'
  get '/admin/categories/import' => 'admin#import_categories'
  get '/admin/events/scrape' => 'admin#scrape'
  
  match '/me' => "users#me", via: [:get, :post]
  put '/me' => "users#update", via: [:put]
  get '/mail' => "users#mail"
  get '/users/events' => 'users#events'
  get '/users/organizations' => 'users#organizations'
  get '/users/subscribed_organizations' => 'users#subscribed_organizations'
  get '/users/subscribed_categories' => 'users#subscribed_categories'
  get '/users/subscriptions' => 'users#subscriptions'
  post '/users/follow/organization/:organization_id' => 'users#follow_organization'
  post '/users/unfollow/organization/:organization_id' => 'users#unfollow_organization'
  post '/users/follow/category/:category_id' => 'users#follow_category'
  post '/users/unfollow/category/:category_id' => 'users#unfollow_category'
  post '/users/bulletin_preference' => "users#bulletin_preference"

  # For testing
  get '/bulletin' => "users#bulletin"
  
  resources :events
  
  resources :organizations
  get '/organizations/slug/:slug' => 'organizations#show_by_slug'
  post '/organizations/:id/add_image' => 'organizations#add_image'
  get '/organizations/:id/events' => 'organizations#events'
  get '/organizations/:id/subscribed_users' => 'organizations#subscribed_users'
  get '/organizations/:id/admins' => 'organizations#admins'
  get '/organizations/:id/email' => 'organizations#subscriber_email'
  
  get '/categories' => 'categories#all'
  get '/categories/:id/events' => 'categories#events'
  get '/categories/slug/:slug' => 'categories#show_by_slug'
  get '/categories/:id' => 'categories#show'
  
  #Search
  get '/search/organizations/:query' => 'organizations#search'
  get '/search/events/:query' => 'events#search'
  get '/search/categories/:query' => 'categories#search'
  get '/search/location/:query' => 'locations#search'
  get '/search/all/:query' => 'main#search_all'
  
end
