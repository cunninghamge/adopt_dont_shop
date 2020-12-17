require 'rails_helper'

RSpec.describe "Admin Shelters Show" do
  before :each do
    @shelter = create(:shelter)

    visit admin_shelter_path(@shelter)
  end

  it 'shows the full name and address of the shelter' do
    expect(page).to have_text(@shelter.name)
    expect(page).to have_text(@shelter.address)
    expect(page).to have_text(@shelter.city)
    expect(page).to have_text(@shelter.state)
    expect(page).to have_text(@shelter.zip)
  end

  describe 'statistics section' do
    it 'has a statistics section' do
      expect(page).to have_text("Statistics")
    end

    it 'shows the average age of all adoptable pets' do
      create(:pet, approximate_age: 1, shelter: @shelter)
      create(:pet, approximate_age: 3, shelter: @shelter)

      visit admin_shelter_path(@shelter)

      expect(page).to have_content("Average Pet Age: 2")
    end

    it 'shows the number of adoptable pets at that shelter' do
      2.times {create(:pet, shelter: @shelter)}
      create(:pet, adoptable: false, shelter: @shelter)

      visit admin_shelter_path(@shelter)

      expect(page).to have_content("Adoptable Pets: 2")
    end

    it 'shows the number of pets that have been adopted' do
      2.times do
        application_pet = create(:application_pet, pet: create(:pet, shelter: @shelter))
        application_pet.update(status: :approved)
      end

      visit admin_shelter_path(@shelter)

      expect(page).to have_content("Pets Adopted: 2")
    end

    it 'does not count pets that are created as not adoptable in adopted pets' do
      2.times do
        application_pet = create(:application_pet, pet: create(:pet, shelter: @shelter))
        application_pet.update(status: :approved)
      end
      create(:pet, adoptable: false, shelter: @shelter)

      visit admin_shelter_path(@shelter)

      expect(page).to have_content("Pets Adopted: 2")
    end
  end

  describe 'action required section' do
    it 'has a section titled "Action Required"' do
      expect(page).to have_content("Action Required")
    end

    it 'lists pets with a pending application that have not been marked "Approved" or "Rejected"' do
      pet_1 = create(:pet, shelter: @shelter)
      pet_2 = create(:pet, shelter: @shelter)
      pet_3 = create(:pet, shelter: @shelter)
      application_1 = create(:application, status: "Pending")
      application_2 = create(:application, status: "Rejected")
      application_3 = create(:application, status: "Approved")
      create(:application_pet, application: application_1, pet: pet_1)
      create(:application_pet, application: application_2, pet: pet_2)
      create(:application_pet, application: application_3, pet: pet_3)

      visit admin_shelter_path(@shelter)

      within("##{pet_1.name}-#{application_1.id}") { expect(page).to have_content(pet_1.name)}
      expect(page).not_to have_css("#{pet_2.name}-#{application_2.id}")
      expect(page).not_to have_css("#{pet_2.name}-#{application_2.id}")
    end

    it 'links to the show page of pending applications next to each pet to be approved/rejected' do
      pet = create(:pet, shelter: @shelter)
      application = create(:application, status: "Pending")
      create(:application_pet, application: application, pet: pet)

      visit admin_shelter_path(@shelter)

      within("##{pet.name}-#{application.id}") { expect(page).to have_link("View Application")}

      within("##{pet.name}-#{application.id}") { click_link("View Application")}

      expect(current_path).to eq(admin_application_path(application))
    end
  end
end
