require 'rails_helper'

describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many :pets }
  end

  describe 'class methods' do
    it 'can find shelters with pending applications' do
      pet = create(:pet)
      application = create(:application, pets: [pet], status: "Pending")
      shelter_1 = pet.shelter
      shelter_2 = create(:shelter)

      expect(Shelter.shelters_with_pending_apps).to eq([shelter_1])
    end

    it '.shelters_with_pending_apps does not find "Rejected" applications' do
      pet = create(:pet)
      application = create(:application, pets: [pet], status: "Rejected")

      expect(Shelter.shelters_with_pending_apps).to eq([])
    end

    it '.shelters_with_pending_apps does not find "Approved" applications' do
      pet = create(:pet)
      application = create(:application, pets: [pet], status: "Approved")

      expect(Shelter.shelters_with_pending_apps).to eq([])
    end

    it '.shelters_with_pending_apps does not find "In Progress" applications' do
      pet = create(:pet)
      application = create(:application, pets: [pet], status: "In Progress")

      expect(Shelter.shelters_with_pending_apps).to eq([])
    end
  end
end
