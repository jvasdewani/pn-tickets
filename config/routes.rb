Tickets::Application.routes.draw do
  # Session paths
  get '/signin', to: 'sessions#new', as: 'new_session'
  post '/signin', to: 'sessions#create', as: 'sessions'
  get '/catch-ya-later', to: 'sessions#destroy', as: 'signout'

  # Password paths
  get '/forgot_password', to: 'passwords#new', as: 'forgot_password'
  post '/forgot_password', to: 'passwords#create', as: 'password_amnesia'
  get '/forgot_password/reset/:token', to: 'passwords#edit', as: 'reset_password'
  post '/forgot_password/reset/:token', to: 'passwords#update', as: 'password_reset'

  resources :issues
  get '/issues/department/:department_id' => 'issues#index'
  get '/widescreen' => 'issues#widescreen', :as => 'widescreen'

  get '/weekly_report' => 'issues#weekly', :as => 'weekly'
  get '/monthly_report' => 'issues#monthly', :as => 'monthly'

  get 'issues/admin_status/:admin_status/:id' => 'issues#index', as: 'admin_status'
  get 'issues/status/:issues_status' => 'issues#index', as: 'issues_status'
  get 'issues/admin/:status' => 'issues#index', as: 'issuesnil'
  resources :searches, only: [ :new, :create, :index ]
  resources :searches_client, only: [ :new, :create, :index ]
  resources :reports, only: [ :new, :create ]
  resources :multi_ticket_edits

  resources :people
  resource :preferences

  resources :clients do
    resources :client_docs
    get :list, :on => :member
    get :healthchecks, :on => :collection
  end
  resources :contacts, :only => [ :create ]

  resources :departments
  resources :task_lists

  resources :contracts do
    member do
      patch :update_time
      get :paid
      get :invoiced
    end
  end
  resources :payment_orders do
    member do
      get :received
      get :raised
      get :fulfilled
      get :invoiced
      get :client_paid
      get :supplier_paid
    end
  end

  resources :quotes do
    get :client_login, on: :member
    post :client_login, on: :member
    get :client_view, on: :member
    get :tech_request, on: :member
    get :client_request, on: :member
    get :phone_approve, on: :member
    get :client_approve, on: :member
    get :goods_received, on: :member
    get :payment_received, on: :member
    get :payment_sent, on: :member
    get :complete, on: :member
  end
  get '/quotes/client/:client_id' => 'quotes#index'

  resources :services

  resources :product_types
  resources :suppliers
  get '/settings' => 'settings#index', as: 'settings'

  resources :reminders do
    member do
      get :paid
      get :invoiced
    end
  end
  resources :reminder_categories
  
  get '/show_ticket/:id' => 'issues#show_ticket', :as => "show_ticket"
  get '/dashboard/:id' => 'issues#index'
  match '/list_ticket' => 'issues#list_ticket', :as => :list_ticket, via: [:get, :post, :patch]
  root :to => 'dashboard#index'
end
