class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
    
  end

  def create
    if session[:userid]
      @player = Player.find_by id: session[:userid]
      if @player.admin
        @match = Match.new(match_params.merge(:away_score => -1, :home_score => -1, :finished => false, :matchday => (Matchday.new)))
        respond_to do |format|
          if @match.save
            format.html { redirect_to action: "index", notice: 'Match was successfully created.' }
            format.json { render :show, status: :created, location: @match }
          else
            render 'matches/new'
          end
        end
      else
        render json: {error: "No permissions", status: 400}, status: 400
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params.merge(:finished => true))
        format.html { redirect_to action: "index", notice: 'Match was successfully updated.' }
        format.json { render :index, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:home_team, :away_team, :home_score, :away_score, :finished)
    end
end
