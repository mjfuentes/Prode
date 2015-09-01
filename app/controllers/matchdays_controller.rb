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
        flash[:notice] = 'Could not create matchday.' 
        redirect_to action: "index"
      end
    else
      flash[:notice] = 'There already is an active matchday.'
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
    @matchday.started = true
    if @matchday.save
      Player.all.each {
        |player|
        if player.email
          PlayerMailer.new_matchday(player).deliver_later
        end
      }
      flash[:notice] = 'Matchday was started successfully.'
      redirect_to @matchday
    else
        flash[:notice] = 'Matchday could not be started.' 
        redirect_to @matchday
    end 
  end

  def end
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.find_by id: params[:id]
    @unfinished_matches = Match.find_by(matchday: @matchday, finished: false)
    if (!@unfinished_matches)
      calculate_points(@matchday)
      @matchday.finished = true
      if @matchday.save
        flash[:notice] = 'Matchday was finished successfully.'
        redirect_to @matchday
      else
        flash[:notice] = 'Matchday could not be finished.'
        redirect_to @matchday
      end
    else
      flash[:notice] = 'There are still active matches.'
      redirect_to @matchday
    end
  end

  # POST /matchdays
  # POST /matchdays.json
  def create
    check_logged_in or return
    check_admin or return
    @matchday = Matchday.new(matchday_params)
    respond_to do |format|
      if @matchday.save
        format.html { 
          flash[:notice] = 'Matchday was successfully created.'
          redirect_to @matchday
        }
        format.json { render :show, status: :created, location: @matchday }
      else
        format.html { render :index }
        format.json { render json: @matchday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matchdays/1
  # PATCH/PUT /matchdays/1.json
  def update
    check_logged_in or return
    check_admin or return
    respond_to do |format|
      if @matchday.update(matchday_params)
        format.html { 
          flash[:notice] = 'Matchday was successfully updated.' 
          redirect_to @matchday
        }
        format.json { render :show, status: :ok, location: @matchday }
      else
        format.html { render :edit }
        format.json { render json: @matchday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchdays/1
  # DELETE /matchdays/1.json
  def destroy
    check_logged_in or return
    check_admin or return
    @matchday.destroy
    respond_to do |format|
      format.html { 
        flash[:notice] = 'Matchday was successfully destroyed.'
        redirect_to @matchday  
      }
      format.json { head :no_content }
    end
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

end
