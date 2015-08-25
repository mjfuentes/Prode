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
    @matchday = Matchday.find_by id: params[:id]
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
    
  end

  def create
    if session[:userid]
      @player = Player.find_by id: session[:userid]
      if @player.admin
        @match = Match.new(match_params.merge(:finished => false))
        respond_to do |format|
          if @match.save
            format.html { 
              flash[:notice] = 'Match was successfully created.'
              redirect_to @match.matchday 
            }
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
        format.html { 
          flash[:notice] = 'Match was successfully updated.'
          redirect_to @match.matchday
        }
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
      format.html { 
        flash[:notice] = 'Match was successfully destroyed.'
        redirect_to @match.matchday
      }
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
      params.require(:match).permit(:home_team, :away_team, :home_score, :away_score, :finished, :matchday_id)
    end
end
