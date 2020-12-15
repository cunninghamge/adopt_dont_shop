ApplicationPet.destroy_all
Application.destroy_all
Pet.destroy_all
Shelter.destroy_all

FactoryBot.create_list(:shelter, 3)

Shelter.all.each do |shelter|
  5.times do
    FactoryBot.create(:pet, shelter: shelter)
  end
end

3.times do
  FactoryBot.create(:application, pets: Pet.all.sample(3), status: "Pending")
  FactoryBot.create(:application, pets: Pet.all.sample(2), status: "Pending")
  FactoryBot.create(:application, pets: [Pet.all.sample], status: "Pending")
  FactoryBot.create(:application)
end
