require 'rails_helper'

RSpec.describe "Admin Shelters Index" do
  it'lists all the shelters in reverse alphabetical order' do
    5.times {create(:shelter)}

    visit admin_shelters_path

    sorted_names = Shelter.order(name: :desc).pluck(:name)
    expect(sorted_names[0]).to appear_before(sorted_names[1])
    expect(sorted_names[1]).to appear_before(sorted_names[2])
    expect(sorted_names[2]).to appear_before(sorted_names[3])
    expect(sorted_names[3]).to appear_before(sorted_names[4])
  end

  it 'has a section for shelters with pending applications' do
    visit admin_shelters_path
    expect(page).to have_content("Shelters with Applications Pending")
  end

  it 'shows the name of every shelter with a pending application' do
    no_app = create(:shelter)
    application_pet_1 = create(:application_pet, application: create(:application, status: "Pending"))
    application_pet_2 = create(:application_pet, application: create(:application, status: "Pending"))
    with_app_1 = application_pet_1.pet.shelter
    with_app_2 = application_pet_2.pet.shelter


    visit admin_shelters_path
    within('#pending') do
      expect(page).to have_content(with_app_1.name)
      expect(page).to have_content(with_app_2.name)
      expect(page).not_to have_content(no_app.name)
    end
  end

  it 'lists shelters with pending applications alphabetically' do
    3.times {create(:application_pet, application: create(:application, status: "Pending"))}

    visit admin_shelters_path

    sorted_names = Shelter.order(:name).pluck(:name)
    within('#pending') do
      expect(sorted_names[0]).to appear_before(sorted_names[1])
      expect(sorted_names[1]).to appear_before(sorted_names[2])
    end
  end

  it 'has links to the show page for each shelter' do
    5.times {create(:shelter)}

    visit admin_shelters_path

    Shelter.pluck(:name).each do |name|
      expect(page).to have_link(name)
    end
  end

  it 'links to the admin show page of each shelter' do
    shelter = create(:shelter)

    visit admin_shelters_path
    click_link(shelter.name)

    expect(current_path).to eq(admin_shelter_path(shelter))
  end
end
