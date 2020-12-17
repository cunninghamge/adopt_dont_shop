require 'rails_helper'

RSpec.describe ApplicationPet do
  describe 'relationships' do
    it { should belong_to :application}
    it { should belong_to :pet}
  end

  describe 'instance methods' do
    before :each do
      @application_pet = create(:application_pet, application: create(:application, status: "Pending"))
    end

    it 'does not have a status on creation' do
      expect(@application_pet.status).to be_nil
    end

    it 'finds the name of its pet' do
      expect(@application_pet.pet_name).to eq(@application_pet.pet.name)
    end

    it 'is approvable if its pet is adoptable' do
      expect(@application_pet.approvable).to be(true)
    end

    it 'is not approvable if its pet is not adoptable' do
      pet = create(:pet, adoptable: false)
      application = create(:application, status: "Pending")
      application_pet = create(:application_pet, pet: pet, application: application)

      expect(application_pet.approvable).to be(false)
    end

    it 'is not approvable if the pet has been approved on another pending application' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application_1 = create(:application, status: "Pending")
      application_pet_1 = create(:application_pet, application: application_1, pet: pet_1)
      application_pet_2 = create(:application_pet, application: application_1, pet: pet_2)
      application_2 = create(:application, status: "Pending")
      application_pet_3 = create(:application_pet, application: application_2, pet: pet_1)
      application_pet_1.update(status: :approved)

      expect(application_1.status).to eq("Pending")
      expect(application_pet_3.approvable).to be(false)
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
      application_pet_1.update(status: :approved)
      application_1.update(status: "Rejected")

      expect(application_pet_3.approvable).to be(true)
    end
  end
end
