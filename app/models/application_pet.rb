class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  after_update :evaluate
  delegate :evaluate, to: :application
  delegate :name, to: :pet, prefix: true

  def approvable
    pet.adoptable && !pet.reserved
  end
end
