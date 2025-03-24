Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  Rails.application.routes.draw do
  get 'current_user/index'
    devise_for :users, path: '', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  end

  resources :users do
    member do
      get :following, to: 'relationships#following'
      get :followers, to: 'relationships#followers'
    end
  end



  resources :relationships, only: [:create, :destroy]


  resources :home, only: [:index]

  resources :profiles, except: [:new, :edit] do
    member do
      get 'tokens', to: 'tokens#index'
    end
    resources :wonks, only: [:index]
  end
  
  resources :products, only: [:index, :create]

  resources :notifications, only: [:index, :show] do
    member do
      patch :mark_as_read
    end
  end

  resources :wonks, only: [:create, :show, :destroy] do
    resources :comments, only: [:index, :show, :create] do
      resources :likes, only: [:create, :destroy]
    end
    resources :likes, only: [:create, :destroy]
  end

  resources :comments, only: [:destroy] 

  resources :chats, only: [:index, :create, :show] do
    resources :messages, only: [:index, :create] 
  end

  resources :challenges, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'entries', to: 'entries#index'
    end
    resources :challenge_participants, only: [:index, :destroy] do
      resources :entries, only: [:index, :show, :create, :update, :destroy] do
        resources :votes, only: [:create] do 
          collection do
            get 'check', to: 'votes#check'
          end
        end
      end
      collection do
        post 'join'  # POST to /challenge_participants/join
        delete 'unjoin'
      end
    end
    resources :likes, only: [:create, :destroy]
  end

  post 'match', to: 'matches#find_matches'

  get 'votes/check_vote', to: 'votes#check_vote'

  resources :tokens do
    collection do
      post :purchase
     end
   end

  resources :favorite_judges, only: [:index]

  resources :judgeships, only: [] do
    member do
      post 'favorite', to: 'favorite_judges#create'
      delete 'favorite', to: 'favorite_judges#destroy'
    end
  end

  # Real-time functionality
  mount ActionCable.server => '/cable'
end
