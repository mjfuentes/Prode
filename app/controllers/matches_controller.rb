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
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.find_by id: params[:id]
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
     @matchday = Matchday.find_by id: @match.matchday_id
  end

  def create
    check_logged_in or return
    check_admin or return
    @player = Player.find_by id: session[:userid]
    @match = Match.new(match_params.merge(:finished => false))
    respond_to do |format|
      if @match.save
        format.html { 
          flash[:notice] = 'Partido creado correctamente.'
          redirect_to @match.matchday 
        }
        format.json { render :show, status: :created, location: @match }
      else
        render 'matches/new'
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    check_logged_in or return
    check_admin or return
    respond_to do |format|
      if @match.update(match_params.merge(:finished => true))
        format.html { 
          flash[:notice] = 'Partido finalizado correcamente.'
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
    check_logged_in or return
    check_admin or return
    @match.destroy
    respond_to do |format|
      format.html { 
        flash[:notice] = 'Partido borrado correctamente..'
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
