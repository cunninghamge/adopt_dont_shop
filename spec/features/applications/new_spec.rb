require 'rails_helper'

RSpec.describe "New Application Page" do
  it 'has a form for creating a new application' do
    visit applications_new_path

    expect(page).to have_selector('form')
    expect(page).to have_field("application[applicant_name]")
    expect(page).to have_field("application[street_address]")
    expect(page).to have_field("application[city]")
    expect(page).to have_field("application[state]")
    expect(page).to have_field("application[zip]")
    expect(page).to have_button(:submit)
  end

  it 'navigates to the new applications show page on submit' do
    visit applications_new_path

    fill_in("application[applicant_name]", with: "Dexter Aufderhar")
    fill_in("application[street_address]", with: "10491 Padberg Pines")
    fill_in("application[city]", with: "West Warner")
    fill_in("application[state]", with: "NJ")
    fill_in("application[zip]", with: "40996")
    click_button(:submit)

    application = Application.first
    expect(page).to have_current_path("/applications/#{application.id}")
    expect(page).to have_content(application.applicant_name)
    expect(page).to have_content(application.street_address)
    expect(page).to have_content(application.city)
    expect(page).to have_content(application.state)
    expect(page).to have_content(application.zip)
    expect(page).to have_content("In Progress")
  end

  describe "visitors cannot submit incomplete applications" do
    it 'applicant_name is required' do
      visit applications_new_path

      fill_in(:address)
      fill_in(:city)
      fill_in(:state)
      fill_in(:zip)
      click_button("Submit")

      expect(page).to have_current_path(applications_new_path)
      expect(page).to have_content("Name is a required field")
    end

    it 'address is required' do
      visit applications_new_path

      fill_in(:applicant_name)
      fill_in(:city)
      fill_in(:state)
      fill_in(:zip)
      click_button("Submit")

      expect(page).to have_current_path(applications_new_path)
      expect(page).to have_content("Address is a required field")
    end

    it 'city is required' do
      visit applications_new_path

      fill_in(:applicant_name)
      fill_in(:city)
      fill_in(:state)
      fill_in(:zip)
      click_button("Submit")

      expect(page).to have_current_path(applications_new_path)
      expect(page).to have_content("City is a required field")
    end

    it 'state is required' do
      visit applications_new_path

      fill_in(:applicant_name)
      fill_in(:address)
      fill_in(:city)
      fill_in(:zip)
      click_button("Submit")

      expect(page).to have_current_path(applications_new_path)
      expect(page).to have_content("State is a required field")
    end

    it 'zip is required' do
      visit applications_new_path

      fill_in(:applicant_name)
      fill_in(:address)
      fill_in(:city)
      fill_in(:state)
      click_button("Submit")

      expect(page).to have_current_path(applications_new_path)
      expect(page).to have_content("Zip is a required field")
    end
  end
end
