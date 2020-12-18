class Admin::ApplicationPetsController < ApplicationController
  def update
    application_pet = ApplicationPet.find(params[:id])
    application_pet.update(status: params[:status])
    redirect_to admin_application_path(application_pet.application_id)
  end
end
