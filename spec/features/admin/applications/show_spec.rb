require 'rails_helper'

describe 'Admin Applications Show page' do
  describe 'approving and rejecting pets' do
    it 'has a button to approve the application for each pet' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application = create(:application, pets: [pet_1, pet_2], status: "Pending")

      visit admin_application_path(application)

      expect(page).to have_button("Approve Pet")
    end

    it 'returns to the application show page when a pet is approved' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application = create(:application, pets: [pet_1, pet_2], status: "Pending")

      visit admin_application_path(application)
      
      within("#pet-#{pet_1.id}") {click_on "Approve Pet"}

      expect(current_path).to eq(admin_application_path(application))
    end

    it 'shows if a pet has been approved' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application = create(:application, pets: [pet_1, pet_2], status: "Pending")

      visit admin_application_path(application)
      within("#pet-#{pet_1.id}") {click_on "Approve Pet"}

      within("#pet-#{pet_1.id}") do
        expect(page).not_to have_button("Approve Pet")
        expect(page).to have_content("Approved")
      end
    end

    it 'has a button to reject the application for each pet' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application = create(:application, pets: [pet_1, pet_2], status: "Pending")

      visit admin_application_path(application)

      expect(page).to have_button("Reject")
    end

    it 'returns to the application show page when a pet is rejected' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application = create(:application, pets: [pet_1, pet_2], status: "Pending")

      visit admin_application_path(application)
      within("#pet-#{pet_1.id}") {click_on "Reject Pet"}

      expect(current_path).to eq(admin_application_path(application))
    end

    it 'shows if a pet has been rejected' do
      pet_1 = create(:pet)
      pet_2 = create(:pet)
      application = create(:application, pets: [pet_1, pet_2], status: "Pending")

      visit admin_application_path(application)
      within("#pet-#{pet_1.id}") {click_on "Reject Pet"}

      within("#pet-#{pet_1.id}") do
        expect(page).not_to have_button("Reject Pet")
        expect(page).to have_content("Rejected")
      end
    end

    it 'does not affect other applications when a pet is approved' do
      pet = create(:pet)
      pet_2 = create(:pet)
      application_1 = create(:application, pets: [pet, pet_2], status: "Pending")
      application_2 = create(:application, pets: [pet], status: "Pending")

      visit admin_application_path(application_1)
      within("#pet-#{pet.id}") {click_on "Approve Pet"}

      visit admin_application_path(application_2)
      within("#pet-#{pet.id}") do
        expect(page).not_to have_content("Approved")
        expect(page).not_to have_content("Rejected")
        expect(page).to have_button("Reject Pet")
      end
    end

    it 'does not affect other applications when a pet is rejected' do
      pet = create(:pet)
      application_1 = create(:application, pets: [pet], status: "Pending")
      application_2 = create(:application, pets: [pet], status: "Pending")

      visit admin_application_path(application_1)
      within("#pet-#{pet.id}") {click_on "Reject Pet"}

      visit admin_application_path(application_2)
      within("#pet-#{pet.id}") do
        expect(page).not_to have_content("Approved")
        expect(page).to have_button("Approve Pet")
        expect(page).not_to have_content("Rejected")
        expect(page).to have_button("Reject Pet")
      end
    end

    it 'does not allow pets that have been approved elsewhere to be approved' do
      pet = create(:pet)
      application_1 = create(:application, pets: [pet], status: "Pending")
      application_2 = create(:application, pets: [pet], status: "Pending")

      visit admin_application_path(application_1)
      within("#pet-#{pet.id}") {click_on "Approve Pet"}

      visit admin_application_path(application_2)

      within("#pet-#{pet.id}") do
        expect(page).to have_content("This pet has been approved for adoption by another applicant")
        expect(page).not_to have_button("Approve Pet")
        expect(page).to have_button("Reject Pet")
      end
    end
  end

  describe 'approving and rejecting applications' do
    it 'approves an application when all pets are approved' do
      application = create(:application, status: "Pending")
      pet_1 = create(:pet, applications: [application])
      pet_2 = create(:pet, applications: [application])

      visit admin_application_path(application)
      within("#pet-#{pet_1.id}") {click_on "Approve Pet"}

      expect(page).to have_content("Status: Pending")

      within("#pet-#{pet_2.id}") {click_on "Approve Pet"}

      expect(page).to have_content("Status: Approved")
    end

    it 'rejects an application when one pet is rejected' do
      application = create(:application, status: "Pending")
      pet_1 = create(:pet, applications: [application])
      pet_2 = create(:pet, applications: [application])

      visit admin_application_path(application)
      within("#pet-#{pet_1.id}") {click_on "Reject Pet"}

      expect(page).to have_content("Status: Rejected")
    end

    it 'rejects an application when any pet is rejected' do
      application = create(:application, status: "Pending")
      pet_1 = create(:pet, applications: [application])
      pet_2 = create(:pet, applications: [application])

      visit admin_application_path(application)
      within("#pet-#{pet_1.id}") {click_on "Approve Pet"}

      expect(page).to have_content("Status: Pending")

      within("#pet-#{pet_2.id}") {click_on "Reject Pet"}

      expect(page).to have_content("Status: Rejected")
    end

    it 'makes pets not adoptable when applications are approved' do
      application = create(:application, status: "Pending")
      pet = create(:pet, applications: [application])

      visit pet_path(pet)
      expect(page).to have_content("Adoption Status: true")

      visit admin_application_path(application)
      within("#pet-#{pet.id}") {click_on "Approve Pet"}

      visit pet_path(pet)
      expect(page).to have_content("Adoption Status: false")
    end
  end
end
