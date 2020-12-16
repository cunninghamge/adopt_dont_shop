class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  after_update :evaluate

  def evaluate
    application.evaluate
  end

  def pet_name
    pet.name
  end

  def approvable?
    pet.adoptable && separately_approved(id, pet.id)
  end

  def separately_approved(id, pet_id)
    ApplicationPet.joins(:application)
                  .where("applications.status='Pending'") .where("application_pets.status='Approved'")
                  .where("application_pets.pet_id = ?", pet_id)
                  .where("application_pets.id <> ?", id)
                  .count == 0
  end
end
