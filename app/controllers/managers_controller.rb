class ManagersController < ApplicationController
  def edit
    @manager = @currentuser
  end

  def update
    @manager = Manager.find(params[:id])
    if @manager.update(manager.id)
        redirect_to '/', notice: 'Operation succeeded'
    else
      render :edit
    end
  end

  def new
    @manager = Manager.new
  end

end
