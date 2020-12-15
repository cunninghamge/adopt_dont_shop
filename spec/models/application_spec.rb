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
    it 'is approved when its pets are approved' do
      application = create(:application, status: "Pending")
      application_pet = create(:application_pet, application: application)
      application_pet.approve
      application.approve

      expect(application.status).to eq("Approved")
    end

    it 'is approved when all of its pets are approved' do
      application = create(:application, status: "Pending")
      2.times {create(:application_pet, application: application)}

      application.application_pets[0].approve
      application.approve

      expect(application.status).to eq("Pending")

      application.application_pets[1].approve
      application.approve

      expect(application.status).to eq("Approved")
    end

    it 'is rejected if any of its pets are rejected' do
      application = create(:application, status: "Pending")
      2.times {create(:application_pet, application: application)}

      application.application_pets[0].approve
      application.approve

      expect(application.status).to eq("Pending")

      application.application_pets[1].reject
      application.approve

      expect(application.status).to eq("Rejected")
    end
  end
end
