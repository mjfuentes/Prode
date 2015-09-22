class MatchdaysController < ApplicationController
  before_action :set_matchday, only: [:show,:start, :end, :simulate_results]

  def index
    authorize! :manage, Matchday
    @matchdays = Matchday.all
  end

  def show
    authorize! :manage, Matchday
    @matches = Match.where matchday: @matchday
  end

  def new
    authorize! :write, Matchday
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
    authorize! :write, Matchday
    if @matchday.start
      flash[:notice] = I18n.t 'matchday.started'
      redirect_to action: "show", id: @matchday.id
    else
      flash[:error] = I18n.t 'matchday.already_started'
      redirect_to action: "show", id: @matchday.id
    end
  end

  def end
    authorize! :write, Matchday
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
    authorize! :write, Matchday
    if @matchday == Matchday.get_active
      @matchday.simulate
      flash[:notice] = I18n.t 'matchday.results_simulated'
      redirect_to action: "show", id: @matchday.id
    else
      flash[:error] = I18n.t 'matchday.no_active_matchday'
      redirect_to home_path
    end
  end

  private
    def set_matchday
      @matchday = Matchday.find_by(id: params[:id])
      if !@matchday
        flash[:error] = I18n.t 'matchday.not_found'
        redirect_to action: "index"
      end
    end

    def matchday_params
      params[:matchday]
    end

end
