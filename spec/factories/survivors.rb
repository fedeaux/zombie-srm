# coding: utf-8
FactoryBot.define do
  factory :survivor do
    sequence(:name) { |n| "Campinas Survivor #{n}" }
    gender { 1 }
    age { 22 }
    latitude { -22.9329 }
    longitude { -47.0738 }
    infected { false }
    water { 3 }
    food { 4 }
    medication { 3 }
    ammunition { 6 }

    trait :infected do
      sequence(:name) { |n| "Infected Survivor #{n}" }
      infected { true }
    end

    trait :from_jundiai do
      sequence(:name) { |n| "Jundiaí Survivor #{n}" }
      latitude { -23.1857 }
      longitude { -46.8978 }
    end

    trait :from_sao_paulo do
      sequence(:name) { |n| "São Paulo Survivor #{n}" }
      latitude { -23.5505 }
      longitude { -46.6333 }
    end
  end
end
