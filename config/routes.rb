Rails.application.routes.draw do
 
  root "home#index"

  devise_for :users

  resources :promotions do
    member do
      post 'generate_coupons'
      post 'approve'
    end

    get 'search', on: :collection
  end

  resources :coupons, only: %i[] do
    patch "inactivate", to: "coupons#inactivate", on:  :member
  end

  resources :product_categories
end
