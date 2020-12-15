class Shelter < ApplicationRecord
  has_many :pets

  def self.shelters_with_pending_apps
    joins(pets: [:application_pets, :applications])
    .where("applications.status = 'Pending'")
    .order(:name)
    .distinct
  end

  def average_pet_age
    pets.average(:approximate_age)
  end

  def adoptable_pet_count
    pets.where(adoptable: true).count
  end

  def pets_adopted
    pets.joins(application_pets: [:application])
    .where("applications.status = 'Approved'")
    .count
  end
end
