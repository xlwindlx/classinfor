class HomeController < ApplicationController
  def index
    @p_rooms = Room.order(:building_id).page(params[:page]).per(15)
    @rooms = Room.all
    @departments = Department.all
    @department = Department.find(1)
  end
end
