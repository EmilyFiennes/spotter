Rails.application.routes.draw do

  resources :users, only: [:show] do
    resources :participations, only: [:destroy], shallow: :true
  end
  root to: 'pages#home'
  resources :events, only: [:show, :destroy]
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Facebook::Messenger::Server, at: 'bot'
end
