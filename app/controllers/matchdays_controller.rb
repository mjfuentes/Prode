class MatchdaysController < ApplicationController
  before_action :set_matchday, only: [:show, :edit, :update, :destroy]

  # GET /matchdays
  # GET /matchdays.json
  def index
    @matchdays = Matchday.all
  end

  # GET /matchdays/1
  # GET /matchdays/1.json
  def show
    check_logged_in or return
    @matches = Match.where matchday: @matchday
  end

  # GET /matchdays/new
  def new
    check_logged_in or return
    check_admin or return
    if (Matchday.where(finished:false).count == 0)
      @matchday = Matchday.new(finished: false, started: false)
      if @matchday.save
        redirect_to action: "show", id: @matchday.id
      else
        flash[:error] = 'No se pudo crear la fecha.' 
        redirect_to action: "index"
      end
    else
      flash[:error] = 'Ya hay una fecha activa.'
      redirect_to action: "index"
    end 
  end

  # GET /matchdays/1/edit
  def edit
  end

  def start
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.find_by id: params[:id]
    if !@matchday.started 
      @matchday.started = true
      if @matchday.save
        @players = Player.where admin: false
        @players.each {
          |player|
          if player.email
            PlayerMailer.new_matchday(player).deliver_later
          end
        }
        flash[:notice] = 'Fecha comenzada correctamente.'
        redirect_to @matchday
      else
        flash[:error] = 'La fecha no se pudo comenzar.' 
        redirect_to @matchday
      end 
    else
      flash[:error] = 'La fecha ya comenzó.' 
      redirect_to @matchday
    end
  end

  def end
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.find_by id: params[:id]
    if !@matchday.finished
      @unfinished_matches = Match.find_by(matchday: @matchday, finished: false)
      if (!@unfinished_matches)
        calculate_points(@matchday)
        @matchday.finished = true
        if @matchday.save
          flash[:notice] = 'Fecha finalizada correctamente.'
          redirect_to @matchday
        else
          flash[:error] = 'La fecha no se pudo finalizar.'
          redirect_to @matchday
        end
      else
        flash[:error] = 'Todavia hay partidos activos.'
        redirect_to @matchday
      end
    else
      flash[:error] = 'La fecha ya finalizó.' 
      redirect_to @matchday
    end
  end

  def calculate_points(matchday)
    matchday.matches.each { 
      |match|
      guesses = Guess.where match_id: match.id
      guesses.each {
        |guess|
        if guess.home_score && guess.away_score
          if (((guess.home_score>guess.away_score) && (match.home_score > match.away_score)) ||
            ((guess.home_score<guess.away_score) && (match.home_score < match.away_score)) ||
            ((guess.home_score == guess.away_score) && (match.home_score == match.away_score)))
            if ((guess.home_score == match.home_score) && (guess.away_score == match.away_score))
              guess.points = 5
            else
              guess.points = 2
            end
          else
            guess.points = 0
          end
        else
          guess.points = 0
        end
        guess.save
      }
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matchday
      @matchday = Matchday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matchday_params
      params[:matchday]
    end

end
