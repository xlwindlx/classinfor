class SearchController < ApplicationController

  def building
    @buildings = Building.all
  end

  def building_floor
    @building = Building.where(number: params[:number])[0]

    # have_floors string을 arr로 바꿈
    hf_arr = []
    have_floors = @building.have_floors
    for i in -6..13 do
      hf_arr.push(i) if (1 << (i + 6) & have_floors) > 0 ? true : false
    end
    # 그 arr에서 hash로 바꾸는데 valid 하면 1
    @floors = {}
    floors = @building.valid_floors
    hf_arr.each do |a|
      @floors[a.to_s] = ((1 << (a + 6)) & floors) > 0 ? true : false
    end
  end

  def building_rooms
    @rooms = Building.where(number: params[:number])[0].rooms.where(floor: params[:floor].to_i)
  end

  def department
    @departments = Department.all
  end

  def department_building

  end

  def department_rooms

  end

end
