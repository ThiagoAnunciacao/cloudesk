Rails3BootstrapDeviseCancan::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resource :cad_local_trabalho, :as => 'cad_local_trabalho', :controller => 'cad_local_trabalho'
end