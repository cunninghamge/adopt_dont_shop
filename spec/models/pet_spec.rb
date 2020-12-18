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
      pet = create(:pet)

      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      pet = create(:pet, adoptable: false)

      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      pet = create(:pet, sex: :male)

      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      pet = create(:pet, sex: :female)

      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end

  describe 'class methods' do
    let!(:fluff) { create(:pet, name: "FLUFF") }
    let!(:fluffy) { create(:pet, name: "Fluffy") }
    let!(:mrfluff) { create(:pet, name: "Mr.Fluff") }
    let!(:spike) { create(:pet, name: "Spike") }

    describe '.search' do
      it 'can search for pets by exact pet name' do
        expect(Pet.search("Fluffy")).to eq([fluffy])
      end

      it 'can search for pets by partial pet name' do
        expect(Pet.search("fluff")).to eq([fluff, fluffy, mrfluff])
      end
    end

    describe '.approve_adoption' do
      it 'changes adoptable to false when approved for adoption' do
        Pet.approve_adoption

        expect(Pet.first.adoptable).to eq(false)
      end

      it 'does not affect all pets if called on a specfic group of pets' do
        fluffy_pets = Pet.search("fluff")
        fluffy_pets.approve_adoption

        spike = Pet.find_by(name: "Spike")
        expect(spike.adoptable).to eq(true)
      end
    end
  end

  describe '#available' do
    let!(:pet_1) {create(:pet)}
    let!(:pet_2) {create(:pet)}
    let!(:application) {create(:application, pets: [pet_1, pet_2], status: "Pending")}

    it 'pets are available if they have not been approved on another application' do
      pet = Pet.find(pet_1.id)
      expect(pet.reserved).to be(false)
    end

    it 'pets are available if they have been approved on a rejected application' do
      ApplicationPet.find_by(pet: pet_1).update(status: :approved)
      ApplicationPet.find_by(pet: pet_2).update(status: :rejected)

      pet = Pet.find(pet_1.id)
      expect(pet.reserved).to be(false)
    end

    it 'pets are not available if they have been approved on a pending application' do
      ApplicationPet.find_by(pet: pet_1).update(status: :approved)

      pet = Pet.find(pet_1.id)
      expect(pet.reserved).to be(true)
    end
  end
end
