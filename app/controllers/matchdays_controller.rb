class MatchdaysController < ApplicationController
  before_action :set_matchday, only: [:show, :edit, :update, :destroy]

  # GET /matchdays
  # GET /matchdays.json
  def index
    @matchdays = Matchday.all
  end

  # GET /matchdays/1
  # GET /matchdays/1.json
  def show
    @matches = Match.find_by matchday: @matchday.id
    render "matches/index"
  end

  # GET /matchdays/new
  def new
    @active_matchday = Matchday.find_by finished: false
    if !@active_matchday
      @matchday = Matchday.new(finished: false)
      if @matchday.save
        redirect_to "/matchdays/" + @matchday.id
      else
        redirect_to action: "index", notice: 'Could not create matchday.' 
      end
    else
      redirect_to action: "index", notice: 'The already is an active matchday.' 
    end
  end

  # GET /matchdays/1/edit
  def edit
  end

  # POST /matchdays
  # POST /matchdays.json
  def create
    @matchday = Matchday.new(matchday_params)

    respond_to do |format|
      if @matchday.save
        format.html { redirect_to @matchday, notice: 'Matchday was successfully created.' }
        format.json { render :show, status: :created, location: @matchday }
      else
        format.html { render :new }
        format.json { render json: @matchday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matchdays/1
  # PATCH/PUT /matchdays/1.json
  def update
    respond_to do |format|
      if @matchday.update(matchday_params)
        format.html { redirect_to @matchday, notice: 'Matchday was successfully updated.' }
        format.json { render :show, status: :ok, location: @matchday }
      else
        format.html { render :edit }
        format.json { render json: @matchday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchdays/1
  # DELETE /matchdays/1.json
  def destroy
    @matchday.destroy
    respond_to do |format|
      format.html { redirect_to matchdays_url, notice: 'Matchday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matchday
      @matchday = Matchday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matchday_params
      params[:matchday]
    end
end
