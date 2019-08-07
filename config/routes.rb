Rails.application.routes.draw do
  resources :list_items
  resources :lists
  devise_for :users
  resources :groups
  resources :channels do
    collection do
      post 'attach_lists', to: 'channels#attach_lists'
      get 'list', to: 'channels#list'
    end
  end
end
