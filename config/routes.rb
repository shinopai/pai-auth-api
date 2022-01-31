Rails.application.routes.draw do
  # users
  namespace :api do
    namespace :v1, default: { format: 'json' } do
      resources :users, only: %i(index create)
    end
  end

  # tasks
  namespace :api do
    namespace :v1, default: { format: 'json' } do
      resources :tasks, only: %i(index create destroy) do
        collection do
          get :search
        end
      end
    end
  end
end
