require 'rails_helper'

RSpec.describe "Application Show Page" do
  describe 'application attributes' do
    describe 'applicant details' do
      it 'displays applicant details' do
        application = create(:application)

        visit application_path(application)

        expect(page).to have_content(application.applicant_name)
        expect(page).to have_content(application.street_address)
        expect(page).to have_content(application.city)
        expect(page).to have_content(application.state)
        expect(page).to have_content(application.zip)
      end
      it 'displays applicant details for a Pending application' do
        application = create(:application, status: "Pending")

        visit application_path(application)

        expect(page).to have_content(application.applicant_name)
        expect(page).to have_content(application.street_address)
        expect(page).to have_content(application.city)
        expect(page).to have_content(application.state)
        expect(page).to have_content(application.zip)
      end
      it 'displays applicant details for a Accepted application' do
        application = create(:application, status: "Accepted")

        visit application_path(application)

        expect(page).to have_content(application.applicant_name)
        expect(page).to have_content(application.street_address)
        expect(page).to have_content(application.city)
        expect(page).to have_content(application.state)
        expect(page).to have_content(application.zip)
      end
      it 'displays applicant details for a Rejected application' do
        application = create(:application, status: "Rejected")

        visit application_path(application)

        expect(page).to have_content(application.applicant_name)
        expect(page).to have_content(application.street_address)
        expect(page).to have_content(application.city)
        expect(page).to have_content(application.state)
        expect(page).to have_content(application.zip)
      end
    end

    describe 'description' do
      it 'does not display a description for applications that have not been submitted' do
        application = create(:application)

        visit application_path(application)

        expect(page).not_to have_content("Why I would make a good home for this pet or pets:")
      end

      it 'displays a description for submitted applications' do
        application = create(:application, status: "Pending")

        visit application_path(application)

        expect(page).to have_content("Why I would make a good home for this pet or pets:")
      end
    end

    describe 'application status' do
      it 'displays the status of a new application' do
        application = create(:application)

        visit application_path(application)

        expect(page).to have_content(application.status)
      end

      it 'displays the status of a Pending application' do
        application = create(:application, status: "Pending")

        visit application_path(application)

        expect(page).to have_content(application.status)
      end

      it 'displays the status of a Accepted application' do
        application = create(:application, status: "Accepted")

        visit application_path(application)

        expect(page).to have_content(application.status)
      end

      it 'displays the status of a Rejected application' do
        application = create(:application, status: "Rejected")

        visit application_path(application)

        expect(page).to have_content(application.status)
      end
    end
  end

  describe 'application pets section' do
    it 'does not have pets by default' do
      application = create(:application)

      visit application_path(application)

      within('#application_pets') {expect(page.text).to eq("Pets")}
    end

    it 'displays the names of all pets with links to their show pages' do
      application = create(:application)
      pet_1 = create(:pet)
      pet_2 = create(:pet)

      ApplicationPet.create(application: application, pet: pet_1)
      ApplicationPet.create(application: application, pet: pet_2)

      visit application_path(application)

      within('#application_pets') {expect(page.text).not_to eq("Pets")}
      expect(page).to have_link(pet_1.name)
      expect(page).to have_link(pet_2.name)
    end
  end

  describe 'add pets section' do
    it 'has a section to add a pet to the application' do
      application = create(:application)

      visit application_path(application)

      expect(page).to have_content("Add a Pet to this Application")
      expect(page).to have_field(:search)
    end

    it 'does not have a section to add pets to a submitted application' do
      application_1 = create(:application, status: "Pending")
      application_2 = create(:application, status: "Accepted")
      application_3 = create(:application, status: "Rejected")

      visit application_path(application_1)
      expect(page).not_to have_button("Add a Pet to this Application")

      visit application_path(application_2)
      expect(page).not_to have_button("Add a Pet to this Application")

      visit application_path(application_3)
      expect(page).not_to have_button("Add a Pet to this Application")

    end

    it 'can search for pets by name' do
      application = create(:application)
      5.times {create(:pet)}

      visit application_path(application)

      pet = Pet.all.sample
      fill_in(:search, with: pet.name)
      click_button("Search")

      expect(current_path).to eq(application_path(application))
      within("#pet-#{pet.id}") do
        expect(page).to have_content(pet.name)
        expect(page).to have_button("Adopt this Pet")
      end
    end

    it 'returns partial matches for pet names' do
      application = create(:application)
      fluff = create(:pet, name: "FLUFF")
      fluffy = create(:pet, name: "Fluffy")
      mrfluff = create(:pet, name: "Mr. Fluff")
      spike = create(:pet, name: "Spike")

      visit application_path(application)

      fill_in(:search, with: "fluff")
      click_button("Search")

      expect(page).to have_content(fluff.name)
      expect(page).to have_content(fluffy.name)
      expect(page).to have_content(mrfluff.name)
      expect(page).not_to have_content(spike.name)
    end

    it 'can add a pet to an application' do
      application = create(:application)
      5.times {create(:pet)}

      visit application_path(application)

      pet = Pet.all.sample
      fill_in(:search, with: pet.name)
      click_button("Search")
      within("#pet-#{pet.id}") {click_button("Adopt this Pet")}

      expect(page).to have_current_path(application_path(application))
      within("#application_pets") do
        expect(page).to have_content(pet.name)
      end
    end
  end

  describe 'submit section' do
    it 'allows the application to be submitted if it has pets' do
      application = create(:application)

      visit application_path(application)

      expect(page).not_to have_css('#submit')

      pet = create(:pet)
      ApplicationPet.create(application: application, pet: pet)
      refresh

      expect(page).to have_css('#submit')
    end

    it 'does not allow submitted applications to be submitted' do
      application_1 = create(:application, status: "Pending")
      application_2 = create(:application, status: "Accepted")
      application_3 = create(:application, status: "Rejected")

      visit application_path(application_1)
      expect(page).not_to have_css('#submit')

      visit application_path(application_2)
      expect(page).not_to have_css('#submit')

      visit application_path(application_3)
      expect(page).not_to have_css('#submit')
    end

    it 'changes the application status on submit' do
      application = create(:application)
      pet = create(:pet)
      ApplicationPet.create(application: application, pet: pet)

      visit application_path(application)
      fill_in(:description, with: "they're good dogs Brent")
      click_button("Submit Application")

      expect(current_path).to eq(application_path(application))
      expect(page).to have_content("Pending")
      expect(page).to have_content(pet.name)
      expect(page).not_to have_css('#add_pets')
    end
  end
end
