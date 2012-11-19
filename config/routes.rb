Gandalf::Application.routes.draw do
  root :to => "main#index"

  match 'feed' => "events#index"
end
