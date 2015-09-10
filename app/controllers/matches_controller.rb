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

  def simulate
    check_logged_in or return
    check_admin or return
    if Matchday.no_active
      @matchday = Matchday.new(finished: false, started: false)
      @matchday.save
      @available_teams = Team.get_available @matchday.id
      while @available_teams.size > 1 do
        @team_one = @available_teams.sample
        @available_teams.delete(@team_one)
        @team_two = @available_teams.sample
        @available_teams.delete(@team_two)
        Match.new(home_team_id: @team_one.id, away_team_id: @team_two.id, matchday_id: @matchday.id, finished: 0).save
      end
      @matchday.start
      flash[:notice] = I18n.t 'matchday.simulated'
      redirect_to home_path
    else 
      flash[:error] = I18n.t 'matchday.active_matchday_exists'
      redirect_to home_path
    end
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:home_team_id, :away_team_id, :home_score, :away_score, :finished, :matchday_id)
    end
end
