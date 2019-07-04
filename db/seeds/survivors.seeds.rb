number_of_survivors = 1_000
infection_chance = 0.2

number_of_survivors.times do
  Survivor.create(
    id: nil,
    name: FFaker::Name.name,
    age: rand(1..100),
    gender: rand(0..1),
    latitude: (rand - 23.1857),
    longitude: (rand - 46.8978),
    infected: rand < infection_chance,
    water: rand(0..10),
    food: rand(0..10),
    medication: rand(0..10),
    ammunition: rand(0..20)
  )
end
