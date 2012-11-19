Gandalf::Application.routes.draw do
  root :to => "main#index"
  match 'logout' => "main#logout"

  match 'feed' => "events#index"
end
