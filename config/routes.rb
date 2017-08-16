Rails.application.routes.draw do
  resources :timetable_normals
  resources :timetable_majors
  get 'timetable/normal'
  get 'timetable/major'

  get 'home/building'
  get 'home/floor'
  get 'home/rent'

  # 내 시간표
  get 'func/timetable'

  # 세가지 검색경로
  get 'search/find_by_building/' => 'search#building'
  get 'search/find_by_building/:number' => 'search#building_floor'
  get 'search/find_by_building/:number/:floor' => 'search#building_rooms'

  get 'search/find_by_department' => 'search#department'
  get 'search/find_by_department/:id' => 'search#department_building'
  get 'search/find_by_department/:id/:number' => 'search#department_rooms'

  # TODO : make filtering search

  # 두가지 옵션
  get 'search/index'
  post 'search/index'
  get 'search' => 'search#index'
  post 'search' => 'search#index'
  get 'gonggang/index'

  # devise
  devise_for :users

  # root로의 접근
  post '/' => 'home#index'
  root 'home#index'
end
