Rails.application.routes.draw do
  resources :jobs do
    member do
      get :similar_jobs
    end
  end
end
