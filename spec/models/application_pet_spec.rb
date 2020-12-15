require 'rails_helper'

RSpec.describe ApplicationPet do
  describe 'relationships' do
    it { should belong_to :application}
    it { should belong_to :pet}
  end

  describe 'instance methods' do
    it 'does not have a status on creation' do
      application_pet = create(:application_pet)

      expect(application_pet.status).to be_nil
    end

    it 'can be approved' do
      application_pet = create(:application_pet)

      application_pet.approve

      expect(application_pet.status).to eq("Approved")
    end

    it 'can be rejected' do
      application_pet = create(:application_pet)

      application_pet.reject

      expect(application_pet.status).to eq("Rejected")
    end

    it 'finds the name of its pet' do
      pet = create(:pet)
      application_pet = create(:application_pet, pet: pet)

      expect(application_pet.pet_name).to eq(pet.name)
    end

    it 'is approvable if its pet is adoptable' do
      pet = create(:pet)
      application_pet = create(:application_pet, pet: pet)

      expect(application_pet.approvable?).to be(true)
    end

    it 'is not approvable if its pet is not adoptable' do
      pet = create(:pet, adoptable: false)
      application_pet = create(:application_pet, pet: pet)

      expect(application_pet.approvable?).to be(false)
    end

    it 'is not approvable if the pet has been approved on another pending application' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      pet_3 = create(:pet)
      application_1 = create(:application, status: "Pending")
      application_pet_1 = create(:application_pet, application: application_1, pet: pet_1)
      application_pet_2 = create(:application_pet, application: application_1, pet: pet_2)
      application_2 = create(:application, status: "Pending")
      application_pet_3 = create(:application_pet, application: application_2, pet: pet_1)
      application_pet_1.approve
      application_1.approve

      expect(application_1.status).to eq("Pending")
      expect(application_pet_3.approvable?).to be(false)
    end

    it 'is approvable if the pet has been approved on separate rejected application' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      pet_3 = create(:pet)
      application_1 = create(:application, status: "Pending")
      application_pet_1 = create(:application_pet, application: application_1, pet: pet_1)
      application_pet_2 = create(:application_pet, application: application_1, pet: pet_2)
      application_2 = create(:application, status: "Pending")
      application_pet_3 = create(:application_pet, application: application_2, pet: pet_1)
      application_pet_1.approve
      application_pet_2.reject
      application_1.approve

      expect(application_1.status).to eq("Rejected")
      expect(application_pet_3.approvable?).to be(true)
    end
  end
end
