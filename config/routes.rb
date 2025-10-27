Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations/registrations',
    sessions: 'sessions/sessions'
  }

  get '/profile', to: 'users#profile'
  get "up" => "rails/health#show", as: :rails_health_check
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end