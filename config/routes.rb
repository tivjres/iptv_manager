Rails.application.routes.draw do
  resources :groups
  resources :channels do
    collection do
      post 'attach_lists', to: 'channels#attach_lists'
      get 'list', to: 'channels#list'
    end
  end
end
