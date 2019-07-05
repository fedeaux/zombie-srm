module Services
  module Reports
    class Main
      def perform
        # With some effort maybe we could reduce the number of queries from 4 to maybe even 1! (UNION?) But then this
        # code would be so unreadable it is not worth

        infected = Survivor.infected.count
        survivors = Survivor.healthy.count
        total = infected + survivors

        infected_percentage = "#{(infected.to_f * 10000).to_i / (total * 100.0)}%"
        survivors_percentage = "#{(survivors.to_f * 10000).to_i / (total * 100.0)}%"

        averages_string = Survivor::RESOURCES.map { |r| "avg(#{r[:name].to_s})" }.join ', '
        averages = Survivor.healthy.pluck(averages_string)
        formated_averages = Survivor::RESOURCES.each_with_index.map { |r, index| [r[:name], (averages[0][index] * 100).to_i/100.0] }.to_h

        sum_string = Survivor::RESOURCES.map { |r| "sum(#{r[:name].to_s}) * #{r[:points]}" }.join ' + '
        sum = Survivor.infected.pluck(sum_string).first

        {
          infected_percentage: infected_percentage,
          survivors_percentage: survivors_percentage,
          average_resources_per_survivor: formated_averages,
          lost_points_to_infected: sum
        }
      end
    end
  end
end
