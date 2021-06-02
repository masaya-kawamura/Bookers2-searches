Rails.application.routes.draw do
  root 'homes#top'
  get 'home/about' => 'homes#about'
  devise_for :users

  resources :users,only: [:show,:index,:edit,:update] do
    member do
      # フォローとフォロワー一覧ページのルーティング
      get :following, :followers
    end
    # フォロー&アンフォローのためのルーティング
    resource :relationships, only: [:create, :destroy]
  end



  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
end