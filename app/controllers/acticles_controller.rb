class ActiclesController < ApplicationController
  before_action :set_acticle, only: [:show, :edit, :update, :destroy]

  # GET /acticles
  # GET /acticles.json
  def index
    @acticles = Acticle.all
  end

  # GET /acticles/1
  # GET /acticles/1.json
  def show
  end

  # GET /acticles/new
  def new
    @acticle = Acticle.new
  end

  # GET /acticles/1/edit
  def edit
  end

  # POST /acticles
  # POST /acticles.json
  def create
    @acticle = Acticle.new(acticle_params)

    respond_to do |format|
      if @acticle.save
        @acticle.create_activity :create, owner: current_user
        format.html { redirect_to @acticle, notice: 'Acticle was successfully created.' }
        format.json { render :show, status: :created, location: @acticle }
      else
        format.html { render :new }
        format.json { render json: @acticle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acticles/1
  # PATCH/PUT /acticles/1.json
  def update
    respond_to do |format|
      if @acticle.update(acticle_params)
        @acticle.create_activity :mess, owner: current_user
        format.html { redirect_to @acticle, notice: 'Acticle was successfully updated.' }
        format.json { render :show, status: :ok, location: @acticle }
      else
        format.html { render :edit }
        format.json { render json: @acticle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acticles/1
  # DELETE /acticles/1.json
  def destroy
    @acticle.destroy
    respond_to do |format|
      # @acticle.create_activity :create, owner: current_user
      # do not create activity here since the object has already been deleted.
      format.html { redirect_to acticles_url, notice: 'Acticle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acticle
      @acticle = Acticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acticle_params
      params.require(:acticle).permit(:name, :description)
    end
end
