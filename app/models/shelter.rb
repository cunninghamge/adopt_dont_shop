class Shelter < ApplicationRecord
  has_many :pets, dependent: :destroy

  delegate :count_adoptable, to: :pets
  delegate :count_adopted, to: :pets
  delegate :average_age, to: :pets, prefix: true
  delegate :pending_action, to: :pets, prefix: true

  def self.shelters_with_pending_apps
    joins(pets: :applications)
    .where("applications.status = 'Pending'")
    .order(:name)
    .distinct
  end
end
