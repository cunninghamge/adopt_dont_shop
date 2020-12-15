require 'rails_helper'

describe Shelter, type: :model do
  before :each do
    @shelter = create(:shelter)
  end

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

  describe 'instance methods' do
    it 'finds the average pet age' do
      create(:pet, approximate_age: 2, shelter: @shelter)
      create(:pet, approximate_age: 4, shelter: @shelter)

      expect(@shelter.average_pet_age).to eq(3)
    end

    it 'counts adoptable pets'do
      create(:pet, shelter: @shelter)
      create(:pet, shelter: @shelter)
      create(:pet, adoptable: false, shelter: @shelter)

      expect(@shelter.adoptable_pet_count).to eq(2)
    end

    it 'counts adopted pets'do
      2.times do
        application_pet = create(:application_pet, pet: create(:pet, shelter: @shelter))
        application_pet.approve
        application_pet.application.approve
      end
      create(:pet, adoptable: false, shelter: @shelter)
      create(:pet, shelter: @shelter)

      expect(@shelter.pets_adopted).to eq(2)
    end
  end
end
