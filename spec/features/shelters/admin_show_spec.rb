require 'rails_helper'

RSpec.describe "Admin Shelters Show" do
  it 'shows the full name and address of the shelter' do
    shelter = create(:shelter)

    visit admin_shelter_path(shelter)

    expect(page).to have_text(shelter.name)
    expect(page).to have_text(shelter.address)
    expect(page).to have_text(shelter.city)
    expect(page).to have_text(shelter.state)
    expect(page).to have_text(shelter.zip)
  end
end
