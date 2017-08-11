class HomeController < ApplicationController
  def index
    @rooms = Room.all
    @departments = Department.all
    @department = Department.find(1)
  end
end
