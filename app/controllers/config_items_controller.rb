class ConfigItemsController < ApplicationController
  before_action :set_config_item, only: %i[ show edit update destroy ]

  # GET /config_items or /config_items.json
  def index
    @config_items = ConfigItem.all
  end

  # GET /config_items/1 or /config_items/1.json
  def show
  end

  # GET /config_items/new
  def new
    @config_item = ConfigItem.new
  end

  # GET /config_items/1/edit
  def edit
  end

  # POST /config_items or /config_items.json
  def create
    @config_item = ConfigItem.new(config_item_params)

    respond_to do |format|
      if @config_item.save
        format.html { redirect_to config_item_url(@config_item), notice: "Config item was successfully created." }
        format.json { render :show, status: :created, location: @config_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @config_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /config_items/1 or /config_items/1.json
  def update
    respond_to do |format|
      if @config_item.update(config_item_params)
        format.html { redirect_to config_item_url(@config_item), notice: "Config item was successfully updated." }
        format.json { render :show, status: :ok, location: @config_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @config_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /config_items/1 or /config_items/1.json
  def destroy
    @config_item.destroy

    respond_to do |format|
      format.html { redirect_to config_items_url, notice: "Config item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config_item
      @config_item = ConfigItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def config_item_params
      params.require(:config_item).permit(:name, :value, :comment)
    end
end
