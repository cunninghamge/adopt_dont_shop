class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  validates_presence_of :name, :description, :approximate_age, :sex
  validates :approximate_age, numericality: {
              greater_than_or_equal_to: 0
            }

  enum sex: [:female, :male]

  def self.search(name)
    where('LOWER(name) LIKE ?', "%#{name.downcase}%").where(adoptable: true)
  end

  def self.approve_adoption
    update_all(adoptable: false)
  end

  def available
    applications.where("applications.status<>'Rejected'")
                .where("application_pets.status='approved'")
                .empty?
  end
end
