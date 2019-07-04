Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :survivors, only: [:create, :update]
      resources :infection_marks, only: [:create]
      resources :trades, only: [:create]
      resources :reports, only: [:index]
    end
  end
end
