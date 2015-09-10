class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

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
      redirect_to @team, notice: t('team.created') 
    else
      render :new 
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: t('team.updated') 
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: t('team.deleted') 
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name)
    end
end
