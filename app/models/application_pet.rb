class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def approve
    self[:status] = "Approved"
  end

  def reject
    self[:status] = "Rejected"
  end
end
