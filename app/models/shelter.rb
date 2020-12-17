class Shelter < ApplicationRecord
  has_many :pets, dependent: :destroy

  delegate :count_adoptable, to: :pets
  delegate :count_adopted, to: :pets
  delegate :average_age, to: :pets, prefix: true

  def self.shelters_with_pending_apps
    joins(pets: [:applications])
    .where("applications.status = 'Pending'")
    .order(:name)
    .distinct
  end

  def pets_pending_action
    pets.select("pets.name, applications.id AS app_id")
        .joins(:applications)
        .where("applications.status = 'Pending'")
        .where("application_pets.status IS NULL")
  end
end
