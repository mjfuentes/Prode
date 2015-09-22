class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @teams = Team.all
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)
    if @team.valid?
      @team.save
      flash[:notice] = I18n.t 'team.created'
      redirect_to @team
    else
      render :new 
    end
  end

  def update
    if @team.update(team_params)
      flash[:notice] = I18n.t 'team.updated'
      redirect_to @team
    else
      render :edit
    end
  end

  def destroy
    if @team.unused?
      @team.destroy
      flash[:notice] = I18n.t 'team.deleted'
      redirect_to teams_url
    else
      flash[:error] = I18n.t 'team.cannot_delete'
      redirect_to teams_url
    end
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name)
    end
end
