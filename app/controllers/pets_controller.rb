class PetsController < ApplicationController
  def index
    @pets = Pet.all
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    Pet.find(params[:id]).update(pets_params)
    redirect_to pet_path(params[:id])
  end

  def destroy
    Pet.destroy(params[:id])
    redirect_to pets_path
  end

  private
  def pets_params
    params.permit(:image, :name, :description, :approximate_age, :sex, :adoptable)
  end
end
