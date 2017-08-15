class HomeController < ApplicationController
  def index
    @p_rooms = Room.order(:building_id).page(params[:page]).per(15)
    @rooms = Room.all
    @room = Room.find(1)
    @departments = Department.all
    @department = Department.find(1)
    @buildings = Building.all

    if params.key?(:search_type)
      # 위치기반 검색
      if params[:search_type] == 'pos'
        a = params[:building][:number]
        @a = Building.find(a).number
        @b = params[:floor]

        @p_rooms = Building.find(a).rooms.where(floor: @b).order(:loc).page(params[:page]).per(15)
      elsif params[:search_type] == 'dep'
        department_array = []
        building_array = []
        floor_array = []

        @c = params[:d]
        @d = params[:b]
        @e = params[:f]

        if @c
          @c.each do |k, v|
            department_array.push(k.to_i)
          end
        end

        if @d
          @d.each do |k, v|
            building_array.push(k.to_i)
          end
        end

        if @e
          @e.each do |k, v|
            floor_array.push(k.to_i)
          end
        end

        @p_rooms = Room.where(department_id: department_array).where(building_id: building_array).where(floor: floor_array).page(params[:page]).per(15)
      end
    end

  end

  def find_by_building
    @buildings = Building.all
  end
  def building_children
    @building = Building.where(number: params[:number])[0]
    @floors = @building.min_floor..@building.max_floor
  end
  def else
    @rooms = Building.where(number: params[:number])[0].rooms.where(floor: params[:floor].to_i)
  end
end
