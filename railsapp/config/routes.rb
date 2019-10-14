Rails.application.routes.draw do
  resources :quakes
  resources :apn_tokens

  root 'pages#root'
  get '/test-notify', to: 'apn_tokens#test_notify'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
