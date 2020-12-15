require 'rails_helper'

describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to :shelter }
    it { should have_many :application_pets }
    it { should have_many(:applications).through(:application_pets) }
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :sex}
    it {should validate_numericality_of(:approximate_age).is_greater_than_or_equal_to(0)}

    it 'is created as adoptable by default' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :male, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end

  describe 'class methods' do
    it 'can search for pets by exact pet name' do
      fluff = create(:pet, name: "FLUFF")
      fluffy = create(:pet, name: "Fluffy")
      mrfluff = create(:pet, name: "Mr. Fluff")
      spike = create(:pet, name: "Spike")

      expect(Pet.search("Fluffy")).to eq([fluffy])
    end

    it 'can search for pets by partial pet name' do
      fluff = create(:pet, name: "FLUFF")
      fluffy = create(:pet, name: "Fluffy")
      mrfluff = create(:pet, name: "Mr. Fluff")
      spike = create(:pet, name: "Spike")

      expect(Pet.search("fluff")).to eq([fluff, fluffy, mrfluff])
    end
  end

  describe 'instance methods' do
    it 'changes adoptable to false when approved for adoption' do
      pet = create(:pet)

      pet.approve_adoption

      expect(pet.adoptable).to eq(false)
    end
  end
end
