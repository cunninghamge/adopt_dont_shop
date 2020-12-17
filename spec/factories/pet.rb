FactoryBot.define do
  factory :pet do
    shelter
    image {"/images/#{rand(1..12)}.jpeg"}
    name {Faker::Creature::Dog.name}
    description {Faker::Creature::Dog.meme_phrase}
    approximate_age {rand(0..15)}
    sex {Faker::Creature::Dog.gender.downcase}
  end
end
