class KaraokesController < ApplicationController
  before_action :set_karaoke, only: [:show, :edit, :update, :destroy]
  before_action :is_admin, only: [:new, :create, :edit, :destroy]

  # GET /karaokes
  # GET /karaokes.json
  def index
    @karaokes = Karaoke.order(created_at: :desc).all
  end

  # GET /karaokes/1
  # GET /karaokes/1.json
  def show
    redirect_to karaokes_url
  end

  # GET /karaokes/new
  def new
    @karaoke = Karaoke.new
  end

  # GET /karaokes/1/edit
  def edit
  end

  # POST /karaokes
  # POST /karaokes.json
  def create
    @karaoke = Karaoke.new(karaoke_params)

    respond_to do |format|
      if @karaoke.save
        format.html { redirect_to @karaoke, notice: 'Karaoke was successfully created.' }
        format.json { render :show, status: :created, location: @karaoke }
      else
        format.html { render :new }
        format.json { render json: @karaoke.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /karaokes/1
  # PATCH/PUT /karaokes/1.json
  def update
    if params[:karaoke].nil?
      add_ballot1
      cookies.permanent[@karaoke.actor.downcase] = @karaoke.ballot1
      redirect_to karaokes_url
    else
      respond_to do |format|
        if @karaoke.update(karaoke_params)
          format.html { redirect_to @karaoke, notice: 'Karaoke was successfully updated.' }
          format.json { render :show, status: :ok, location: @karaoke }
        else
          format.html { render :edit }
          format.json { render json: @karaoke.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /karaokes/1
  # DELETE /karaokes/1.json
  def destroy
    @karaoke.destroy
    respond_to do |format|
      format.html { redirect_to karaokes_url, notice: 'Karaoke was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_karaoke
      @karaoke = Karaoke.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def karaoke_params
      params.require(:karaoke).permit(:actor, :introduction, :picture, :video1, :video2, :ballot1, :vote)
    end

    def is_admin
      redirect_to root_url unless admin_logged?
    end

    def add_ballot1
      if cookies.permanent[@karaoke.actor.downcase].nil? && @karaoke.vote?
        @karaoke.update_attribute(:ballot1, @karaoke.ballot1 + 1)
      end
    end
end
