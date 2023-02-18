Rails.application.routes.draw do
  resources :servers
  resources :ips do
    collection do
    end
  end
  resources :ip_mappings

  # Defines the root path route ("/")
  # root "articles#index"
end
