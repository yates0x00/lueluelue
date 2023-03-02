Rails.application.routes.draw do
  root "servers#index"
  devise_for :managers, controllers: {
    registrations: 'managers/registrations',
    passwords: 'managers/passwords',
    sessions: 'managers/sessions'
  }
  devise_scope :manager do
    get '/managers/sign_out' => 'devise/sessions#destroy'
  end

  resources :projects
  resources :servers do
    collection do
      get :new_some_servers
      post :create_some_servers
    end
  end
  resources :emails
  resources :ips do
    collection do
      get :new_some_ips
      post :create_some_ips
    end
  end
  resources :ip_mappings
end
