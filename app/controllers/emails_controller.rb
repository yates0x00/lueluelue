class EmailsController < ApplicationController
  before_action :set_email, only: %i[ show edit update destroy ]

  # GET /emails or /emails.json
  def index
    @emails = Email.all
    @emails = @emails.joins(:server).where("servers.name like ?", "%#{params[:like_name]}%") if params[:like_name].present?
    @emails = @emails.joins(:server).where("servers.name like ?", "%#{params[:like_name]}%") if params[:like_name].present?
    @emails = @emails.joins(:project).where("projects.id = ?", params[:project_id]) if params[:project_id].present?
    @total_count = @emails.count
    @emails = @emails.order("id desc").page(params[:page]).per(500)
  end

  # GET /emails/1 or /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails or /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to email_url(@email), notice: "Email was successfully created." }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1 or /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to email_url(@email), notice: "Email was successfully updated." }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1 or /emails/1.json
  def destroy
    @email.destroy

    respond_to do |format|
      format.html { redirect_to emails_url, notice: "Email was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download_csv
    require 'csv'

    headers = %w{ID Address Project Server}
    file = CSV.generate do |csv|
      csv << headers
      Email.all.each_with_index do |email, index|
        row = [email.id, email.address, email.project.try(:name), email.server.try(:name)]
        csv << row
      end
    end
    send_data file.encode("utf-8", "utf-8"), :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment;filename=emails.csv"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_params
      params.require(:email).permit(:project_id, :server_id, :address)
    end
end
