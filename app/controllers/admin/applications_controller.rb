class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    application_pet = ApplicationPet.find_by(application_id: params[:id], pet_id: params[:pet])
    application_pet.update(status: params[:status])
    redirect_to admin_path(params[:id])
  end
end
