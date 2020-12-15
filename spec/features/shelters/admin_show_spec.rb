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
        application_pet.approve
        application_pet.application.approve
      end

      expect(page).to have_content("Pets Adopted: 2")
    end

    it 'does not count pets that are created as not adoptable in adopted pets' do
      2.times do
        application_pet = create(:application_pet, pet: create(:pet, shelter: @shelter))
        application_pet.approve
        application_pet.application.approve
      end
      create(:pet, adoptable: false, shelter: @shelter)

      expect(page).to have_content("Pets Adopted: 2")
    end
  end

  describe 'action required section' do
    it 'has a section titled "Action Required"'
    it 'lists pets with a pending application that have not been marked "Approved" or "Rejected"'
    it 'links to the show page of pending applications next to each pet to be approved/rejected'
  end
end
