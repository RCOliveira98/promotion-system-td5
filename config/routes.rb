Rails.application.routes.draw do
 
  root "home#index"

  devise_for :users

  resources :promotions do
    post 'generate_coupons', on: :member
  end

  resources :coupons, only: %i[] do
    patch "inactivate", to: "coupons#inactivate", on:  :member
  end

  resources :product_categories
end
