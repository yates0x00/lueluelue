Rails.application.routes.draw do
  root "servers#index"
  devise_for :managers
  resources :projects
  resources :servers
  resources :emails
  resources :ips do
    collection do
    end
  end
  resources :ip_mappings
end
