class ApplicationsController < ApplicationController
  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to application_path(@application)
    else
      flash.now[:notice] = @application.errors.full_messages
      render :new, obj: @application
    end
  end

  def show
    @application = Application.find(params[:id])
    @adoptable_pets = Pet.search(params[:search]) if params[:search]
  end

  def update
    @application = Application.find(params[:id])
    @application.update(status: params[:status], description: params[:description])
    render :show
  end

  private
  def application_params
    params.require(:application).permit(:applicant_name, :street_address, :city, :state, :zip)
  end
end
