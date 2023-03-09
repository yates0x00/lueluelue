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

  resources :projects do
    collection do
      get :download_csv
    end
  end
  resources :servers do
    collection do
      get :new_batch_servers
      post :create_batch_servers
      get :download_csv
    end
  end
  resources :emails do
    collection do
      get :download_csv
    end
  end
  resources :ips do
    collection do
      get :new_batch_ips
      post :create_batch_ips
      get :download_csv
    end
  end
  resources :ip_mappings do
    collection do
      get :download_csv
    end
  end

end
