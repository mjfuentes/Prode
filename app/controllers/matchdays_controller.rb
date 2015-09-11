class MatchdaysController < ApplicationController
  load_and_authorize_resource
  before_action :set_matchday, only: [:show, :edit, :update, :destroy]

  def index
    @matchdays = Matchday.all
  end

  def show
    @matches = Match.where matchday: @matchday
  end

  def new
    if (Matchday.no_active)
        @matchday = Matchday.new(finished: false, started: false)
        @matchday.save
        redirect_to action: "show", id: @matchday.id
    else
      flash[:error] = I18n.t 'matchday.active_matchday_exists'
      redirect_to action: "index"
    end 
  end

  def start
    @matchday = Matchday.find_by id: params[:id]
    if @matchday.start
      flash[:notice] = I18n.t 'matchday.started'
      redirect_to action: "show", id: @matchday.id
    else
      flash[:error] = I18n.t 'matchday.already_started'
      redirect_to action: "show", id: @matchday.id
    end
  end

  def end
    @matchday = Matchday.find_by id: params[:id]
    if !@matchday.finished
      if @matchday.finish
        flash[:notice] = I18n.t 'matchday.ended'
        redirect_to @matchday
      else
        flash[:error] = I18n.t 'matchday.active_matchdays'
        redirect_to @matchday
      end
    else
      flash[:error] = I18n.t 'matchday.already_ended' 
      redirect_to @matchday
    end
  end

  def simulate_results
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.get_active
    if @matchday
      @matchday.simulate
      flash[:notice] = I18n.t 'matchday.results_simulated'
      redirect_to action: "show", id: @matchday.id
    else
      flash[:error] = I18n.t 'matchday.no_active_matchday_exists'
      redirect_to home_path
    end
  end

  private
    def set_matchday
      @matchday = Matchday.find(params[:id])
    end

    def matchday_params
      params[:matchday]
    end

end
