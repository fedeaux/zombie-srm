class Survivor < ApplicationRecord
  RESOURCES = [
    { name: :water, points: 4 },
    { name: :food, points: 3 },
    { name: :medication, points: 2 },
    { name: :ammunition, points: 1 }
  ].freeze

  has_many :infection_marks, foreign_key: "to_id", class_name: "InfectionMark"
end
