Dummy::Application.routes.draw do
  root to: 'home#index'

  resources :posts, only: [:index, :show] do
    collection do
      get "filter/:tag", action: 'filter', as: 'filter'
    end
  end

end
