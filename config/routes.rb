Rails.application.routes.draw do
  resources :projects
  resources :servers
  resources :emails
  resources :ips do
    collection do
    end
  end
  resources :ip_mappings

  # Defines the root path route ("/")
  # root "articles#index"
end
