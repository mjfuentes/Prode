class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  def index
    @matches = Match.all
  end

  def show
  end

  def new
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.find_by id: params[:id]
    @teams = Team.get_available @matchday.id
    if @teams.size < 2
      flash[:error] = I18n.t 'match.no_available_teams'
      redirect_to @matchday
    end 
    @match = Match.new
  end

  def edit
     @matchday = Matchday.find_by id: @match.matchday_id
  end

  def create
    check_logged_in or return
    check_admin or return
    @player = Player.find_by id: session[:userid]
    @match = Match.new(match_params.merge(:finished => false))
    if @match.valid?
        @match.save
        flash[:notice] = I18n.t 'match.created'
        redirect_to @match.matchday 
    else
      @matchday = @match.matchday
      @teams = Team.get_available @matchday.id
      render 'matches/new'
    end  
  end

  def update
    check_logged_in or return
    check_admin or return
    if @match.update(match_params.merge(:finished => true))
        flash[:notice] = I18n.t 'match.ended'
        redirect_to @match.matchday
    else
      @matchday = @match.matchday
      render :edit
    end
  end

  def destroy
    check_logged_in or return
    check_admin or return
    @match.destroy
    flash[:notice] = I18n.t 'match.deleted'
    redirect_to @match.matchday
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:home_team_id, :away_team_id, :home_score, :away_score, :finished, :matchday_id)
    end
end
