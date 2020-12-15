class Shelter < ApplicationRecord
  has_many :pets

  def self.shelters_with_pending_apps
    joins(pets: [:application_pets, :applications]).where("applications.status = 'Pending'").distinct
  end
end
