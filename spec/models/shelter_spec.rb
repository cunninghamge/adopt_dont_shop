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

      expect(@shelter.count_adoptable).to eq(2)
    end

    it 'counts adopted pets'do
      2.times do
        application_pet = create(:application_pet, pet: create(:pet, shelter: @shelter))
        application_pet.update(status: :approved)
      end
      create(:pet, adoptable: false, shelter: @shelter)
      create(:pet, shelter: @shelter)

      expect(@shelter.pets_adopted).to eq(2)
    end

    it 'finds pets on pending applications that have not been approved or rejected' do
      pet = create(:pet, shelter: @shelter)
      create(:application, pets: [pet],status: "Pending")

      expect(@shelter.pets_pending_action.pluck(:name)).to eq([pet.name])
    end

    it 'does not consider rejected applications as needing action' do
      pet = create(:pet, shelter: @shelter)
      application = create(:application, pets: [pet],status: "Rejected")

      expect(@shelter.pets_pending_action).to be_empty
    end

    it 'does not consider pets as needing action if they have already been approved or rejected' do
      pet_1 = create(:pet, shelter: @shelter)
      pet_2 = create(:pet, shelter: @shelter)
      create(:application_pet, pet: pet_1).update(status: :approved)
      create(:application_pet, pet: pet_2).update(status: :rejected)

      expect(@shelter.pets_pending_action).to be_empty
    end

    it 'still consideres pets as needing approval if they have been approved on a separate application' do
      pet = create(:pet, shelter: @shelter)
      app_pet_1 = create(:application_pet, pet: pet, application: create(:application, status: "Pending"))
      app_pet_2 = create(:application_pet, pet: pet, application: create(:application, status: "Pending"))
      app_pet_1.update(status: :approved)

      expect(@shelter.pets_pending_action.pluck(:name)).to eq([pet.name])
    end
  end
end
