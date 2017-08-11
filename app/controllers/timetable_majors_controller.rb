class TimetableMajorsController < ApplicationController
  before_action :set_timetable_major, only: [:show, :edit, :update, :destroy]

  # GET /timetable_majors
  # GET /timetable_majors.json
  def index
    # @timetable_majors = TimetableMajor.all
    @timetable_majors = TimetableMajor.page(params[:page])
  end

  # GET /timetable_majors/1
  # GET /timetable_majors/1.json
  def show
  end

  # GET /timetable_majors/new
  def new
    @timetable_major = TimetableMajor.new
  end

  # GET /timetable_majors/1/edit
  def edit
  end

  # POST /timetable_majors
  # POST /timetable_majors.json
  def create
    @timetable_major = TimetableMajor.new(timetable_major_params)

    respond_to do |format|
      if @timetable_major.save
        format.html { redirect_to @timetable_major, notice: 'Timetable major was successfully created.' }
        format.json { render :show, status: :created, location: @timetable_major }
      else
        format.html { render :new }
        format.json { render json: @timetable_major.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timetable_majors/1
  # PATCH/PUT /timetable_majors/1.json
  def update
    respond_to do |format|
      if @timetable_major.update(timetable_major_params)
        format.html { redirect_to @timetable_major, notice: 'Timetable major was successfully updated.' }
        format.json { render :show, status: :ok, location: @timetable_major }
      else
        format.html { render :edit }
        format.json { render json: @timetable_major.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timetable_majors/1
  # DELETE /timetable_majors/1.json
  def destroy
    @timetable_major.destroy
    respond_to do |format|
      format.html { redirect_to timetable_majors_url, notice: 'Timetable major was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable_major
      @timetable_major = TimetableMajor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetable_major_params
      params.fetch(:timetable_major, {})
    end
end
