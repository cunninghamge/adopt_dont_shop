class ShelterPetsController < ApplicationController
  def index
    @shelter = Shelter.find(params[:shelter_id])
  end

  def new
    @shelter = Shelter.find(params[:shelter_id])
  end

  def create
    Pet.create(shelter_pets_params)
    redirect_to shelter_pets_path(params[:shelter_id])
  end

  private
  def shelter_pets_params
    params.permit(:image, :name, :description, :approximate_age, :sex, :adoptable, :shelter_id)
  end
end
