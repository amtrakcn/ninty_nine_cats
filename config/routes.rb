NintyNineCats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    member do
      post 'approve'
      post 'deny'
    end
  end
end
