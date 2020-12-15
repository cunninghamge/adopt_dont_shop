class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def approve
    self[:status] = "Approved"
    save
  end

  def reject
    self[:status] = "Rejected"
    save
  end

  def pet_name
    pet.name
  end

  def approvable?
    pet.adoptable && separately_approved(id, pet.id)
  end

  def separately_approved(id, pet_id)
    ApplicationPet.joins(:application)
                  .where("applications.status='Pending' AND application_pets.status='Approved'")
                  .where("application_pets.pet_id = ?", pet_id)
                  .where("application_pets.id <> ?", id)
                  .count == 0
  end
end
