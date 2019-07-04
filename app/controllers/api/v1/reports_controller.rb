class Api::V1::ReportsController < Api::V1::ApiController
  def index
    infected = Survivor.infected.count
    survivors = Survivor.healthy.count
    total = infected + survivors

    averages_string = Survivor::RESOURCES.map { |r| "avg(#{r[:name].to_s})" }.join ', '
    averages = Survivor.healthy.pluck(averages_string)

    sums = Survivor.infected.pluck('sum(water)')

    render json: { infected_ratio: infected.to_f / total, survivors_ratio: survivors.to_f / total, averages_per_survivor: averages, lost_points_to_infected: sums }

    # Ta quase!!!!!!!!!!!!111111111onze
  end
end
