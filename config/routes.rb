Rails.application.routes.draw do
  scope "genie" do
    resources :jobs do
      member do
        get :similar_jobs
      end
    end
  end
end
