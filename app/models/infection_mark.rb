class InfectionMark < ApplicationRecord
  belongs_to :from, class_name: 'Survivor'
  belongs_to :to, class_name: 'Survivor'

  after_create :check_marked_infection
  validate :validate_not_marking_himself_as_infected
  validates_uniqueness_of :from_id, scope: [:to_id]

  def check_marked_infection
    return if to.infected? or to.infection_marks.count < 3
    to.update(infected: true)
  end

  def validate_not_marking_himself_as_infected
    return unless from_id == to_id
    errors.add(:to_id, "Survivors can't mark themselves as infected")
  end
end
