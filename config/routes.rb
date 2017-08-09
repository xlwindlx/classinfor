Rails.application.routes.draw do
  resources :timetable_normals
  resources :timetable_majors
  get 'timetable/normal'
  get 'timetable/major'

  devise_for :users
  root 'home#index'

  get 'home/building'
  get 'home/floor'
  get 'home/rent'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
