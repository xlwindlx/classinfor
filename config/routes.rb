Rails.application.routes.draw do
  resources :timetable_normals
  resources :timetable_majors
  get 'timetable/normal'
  get 'timetable/major'

  devise_for :users
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
