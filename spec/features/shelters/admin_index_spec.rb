require 'rails_helper'

RSpec.describe "Admin Shelters Index" do
  it'lists all the shelters in reverse alphabetical order' do
    5.times {create(:shelter)}

    visit admin_shelters_path

    shelter_names = Shelter.pluck(:name).sort.reverse
    expect(shelter_names[0]).to appear_before(shelter_names[1])
    expect(shelter_names[1]).to appear_before(shelter_names[2])
    expect(shelter_names[2]).to appear_before(shelter_names[3])
    expect(shelter_names[3]).to appear_before(shelter_names[4])
  end
end
