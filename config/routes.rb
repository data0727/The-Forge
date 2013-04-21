RebelFoundation::Application.routes.draw do

  # Users
  resources :users 
  resources :projects do
    resources :transactions, controller: 'projects/transactions'
    resources :epics, controller: 'projects/epics' do
      resources :stories, controller: 'projects/epics/stories' do
        member do
          get :start
          get :finish
          get :deliver
          get :deny
          put :denied
          get :accept
          get :restart
        end
        resources :comments, controller: 'projects/epics/stories/comments'
      end
    end
    resources :users, controller: 'projects/users'
  end

  # Applies to the logged in user
  match '/dashboard' => 'users#dashboard', as: :dashboard
  match '/profile'   => 'users#edit',      as: :profile

  # Session
  resource  :session
  match '/logout' => 'session#destroy', as: :logout

  # OAuth how you humor me so ...
  match '/auth/:provider/callback' => 'session#create'
  
  root to: 'homepages#index'
end
