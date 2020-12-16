class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :applicant_name, :street_address, :city, :state, :zip

  def evaluate
    if application_pets.all? {|pet| pet.status=="approved"}
      update(status: "Approved")
      pets.each {|pet| pet.approve_adoption}
    elsif application_pets.any? {|pet| pet.status=="rejected"}
      update(status: "Rejected")
    end
  end
end
