require 'rails_helper'

RSpec.describe Application do
  describe 'relationships' do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of :applicant_name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }

    it 'has a status of In Progress by default' do
      application = create(:application)

      expect(application.status).to eq("In Progress")
    end
  end

  describe 'instance methods' do
    describe '#all_pets_approved' do
      before :each do
        @application = create(:application, pets: [create(:pet), create(:pet)], status: "Pending")
      end

      it 'returns true if all application_pets are approved' do
        ApplicationPet.first.update(status: :approved)
        ApplicationPet.last.update(status: :approved)

        application = Application.first
        expect(application.all_pets_approved).to eq(true)
      end

      it 'returns false if any application_pets are not approved' do
        ApplicationPet.first.update(status: :approved)

        application = Application.first
        expect(application.all_pets_approved).to eq(false)
      end

      it 'returns false if any application_pets are rejected' do
        ApplicationPet.first.update(status: :rejected)

        application = Application.first
        expect(application.all_pets_approved).to eq(false)
      end
    end

    describe '#any_pets_rejected' do
      before :each do
        create(:application, pets: [create(:pet), create(:pet)], status: "Pending")
      end

      it 'returns true if any application_pets are rejected' do
        ApplicationPet.first.update(status: :rejected)

        application = Application.first
        expect(application.any_pets_rejected).to eq(true)
      end

      it 'returns false if no application_pets are rejected' do
        ApplicationPet.first.update(status: :approved)

        application = Application.first
        expect(application.any_pets_rejected).to eq(false)
      end
    end

    describe '#evaluate' do
      let(:application) {create(:application, status: "Pending")}

      it 'is approved when all of its pets are approved' do
        create(:application_pet, application: application, status: :approved)

        Application.first.evaluate

        expect(Application.first.status).to eq("Approved")
      end

      it 'is not approved until all pets are approved'do
        2.times {create(:application_pet, application: application)}

        ApplicationPet.first.update(status: :approved)

        expect(Application.first.status).to eq("Pending")

        ApplicationPet.last.update(status: :approved)

        expect(Application.first.status).to eq("Approved")
      end

      it 'is rejected if a single pet is rejected' do
        2.times {create(:application_pet, application: application)}

        ApplicationPet.first.update(status: :rejected)

        expect(Application.first.status).to eq("Rejected")
      end

      it 'is rejected if any of its pets are rejected' do
        2.times {create(:application_pet, application: application)}

        ApplicationPet.first.update(status: :approved)

        expect(Application.first.status).to eq("Pending")

        ApplicationPet.last.update(status: :rejected)

        expect(Application.first.status).to eq("Rejected")
      end
    end
  end
end
