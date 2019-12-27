Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :dogs, only: :index
      resources :table_prices, only: :index

      resources :dog_walkings, except: [:update, :destroy] do
        member do
          patch :start_walking
          patch :finish_walking
        end
      end
    end
  end
end
