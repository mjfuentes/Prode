class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def new
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
    if !@match.is_active
      flash[:error] = I18n.t 'match.already_finished'
      redirect_to @match.matchday 
    end
  end

  def create
    @player = User.find_by id: session[:userid]
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
    if @match.update(match_params.merge(:finished => true))
        flash[:notice] = I18n.t 'match.ended'
        redirect_to @match.matchday
    else
      @matchday = @match.matchday
      render :edit
    end
  end

  def destroy
    if @match.matchday.not_started
      @match.destroy
      flash[:notice] = I18n.t 'match.deleted'
      redirect_to @match.matchday
    else
      flash[:error] = I18n.t 'match.already_started'
      redirect_to @match.matchday
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
