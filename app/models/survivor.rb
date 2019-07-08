class Survivor < ApplicationRecord
  enum gender: [ :male, :female ]

  RESOURCES = [
    { name: :water, points: 4 },
    { name: :food, points: 3 },
    { name: :medication, points: 2 },
    { name: :ammunition, points: 1 }
  ].freeze

  has_many :infection_marks, foreign_key: "to_id", class_name: "InfectionMark"

  scope :infected, ->{ where(infected: true) }
  scope :healthy, ->{ where(infected: false) }

  def points
    RESOURCES.map do |resource|
      send(resource[:name]) * resource[:points]
    end.inject(:+)
  end
end
