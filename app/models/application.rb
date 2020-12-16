class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :applicant_name, :street_address, :city, :state, :zip

  def evaluate
    if all_pets_approved
      update(status: "Approved")
      pets.approve_adoption
    elsif any_pets_rejected
      update(status: "Rejected")
    end
  end

  def all_pets_approved
    application_pets.all? {|app_pet| app_pet.status=="approved"}
  end

  def any_pets_rejected
    application_pets.any? {|app_pet| app_pet.status=="rejected"}
  end
end
