class SheltersController < ApplicationController
  def index
    @shelters = Shelter.all
  end

  def show
    @shelter = Shelter.find(params[:id])
  end

  def create
    Shelter.create(shelter_params)
    redirect_to shelters_path
  end

  def edit
    @shelter = Shelter.find(params[:id])
  end

  def update
    Shelter.find(params[:id]).update(shelter_params)
    redirect_to shelter_path(params[:id])
  end

  def destroy
    Shelter.destroy(params[:id])
    redirect_to shelters_path
  end

  private
  def shelter_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
