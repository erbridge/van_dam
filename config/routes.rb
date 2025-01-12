Rails.application.routes.draw do
  root to: "libraries#index"
  resources :libraries, only: [:index, :show, :new, :create, :update] do
    resources :models, except: [:index, :destroy] do
      collection do
        get "edit", action: "bulk_edit"
        patch "update", action: "bulk_update"
      end
      resources :parts, except: [:index, :destroy]
    end
  end
  resources :creators
end
