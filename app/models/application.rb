class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :applicant_name, :street_address, :city, :state, :zip

  def approve
    if application_pets.all? {|pet| pet.status=="Approved"}
      self[:status] = "Approved"
    elsif application_pets.any? {|pet| pet.status=="Rejected"}
      self[:status] = "Rejected"
    end
  end
end
