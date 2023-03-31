Rails.application.routes.draw do
  namespace :feishu do
    namespace :dalle do
      resources :events, only: [:create]
    end
    namespace :chatgpt do
      resources :events, only: [:create]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :feishu_events, only: [:create]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  if Rails.env.development?
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end
end
