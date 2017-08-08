class TimetableNormalsController < ApplicationController
  before_action :set_timetable_normal, only: [:show, :edit, :update, :destroy]

  # GET /timetable_normals
  # GET /timetable_normals.json
  def index
    @timetable_normals = TimetableNormal.all
  end

  # GET /timetable_normals/1
  # GET /timetable_normals/1.json
  def show
  end

  # GET /timetable_normals/new
  def new
    @timetable_normal = TimetableNormal.new
  end

  # GET /timetable_normals/1/edit
  def edit
  end

  # POST /timetable_normals
  # POST /timetable_normals.json
  def create
    @timetable_normal = TimetableNormal.new(timetable_normal_params)

    respond_to do |format|
      if @timetable_normal.save
        format.html { redirect_to @timetable_normal, notice: 'Timetable normal was successfully created.' }
        format.json { render :show, status: :created, location: @timetable_normal }
      else
        format.html { render :new }
        format.json { render json: @timetable_normal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timetable_normals/1
  # PATCH/PUT /timetable_normals/1.json
  def update
    respond_to do |format|
      if @timetable_normal.update(timetable_normal_params)
        format.html { redirect_to @timetable_normal, notice: 'Timetable normal was successfully updated.' }
        format.json { render :show, status: :ok, location: @timetable_normal }
      else
        format.html { render :edit }
        format.json { render json: @timetable_normal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timetable_normals/1
  # DELETE /timetable_normals/1.json
  def destroy
    @timetable_normal.destroy
    respond_to do |format|
      format.html { redirect_to timetable_normals_url, notice: 'Timetable normal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable_normal
      @timetable_normal = TimetableNormal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetable_normal_params
      params.fetch(:timetable_normal, {})
    end
end
