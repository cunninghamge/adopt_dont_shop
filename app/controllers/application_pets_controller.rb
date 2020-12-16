class ApplicationPetsController < ApplicationController
  def create
    ApplicationPet.create(pet_id: params[:pet], application_id: params[:id])
    redirect_to application_path(params[:id])
  end
end
