module Services
  module Trades
    class Perform
      def perform(trade_params)
        @survivor_trade_0 = trade_params[0]
        @survivor_trade_1 = trade_params[1]

        @survivor_trade_0[:survivor] = Survivor.find @survivor_trade_0['survivor_id']
        @survivor_trade_1[:survivor] = Survivor.find @survivor_trade_1['survivor_id']

        normalize_params

        infection_status = check_infection
        return infection_status if infection_status[:status] == 'error'

        ammounts_status = check_ammounts
        return ammounts_status if ammounts_status[:status] == 'error'

        points_status = check_points
        return points_status if points_status[:status] == 'error'

        perform_trade
        { status: 'success '}
      end

      def check_infection
        return { status: 'success '} unless @survivor_trade_0[:survivor].infected? || @survivor_trade_1[:survivor].infected?
        { status: 'error', message: "Can't trade with the infected"}
      end

      def normalize_params
        [@survivor_trade_0, @survivor_trade_1].each do |survivor_trade|
          Survivor::RESOURCES.each do |resource|
            if survivor_trade.has_key? resource[:name]
              survivor_trade[resource[:name]] = survivor_trade[resource[:name]].to_i
              next
            end

            survivor_trade[resource[:name]] = 0
          end
        end
      end

      def check_ammounts
        [@survivor_trade_0, @survivor_trade_1].each do |survivor_trade|
          Survivor::RESOURCES.each do |resource|
            next if survivor_trade[resource[:name]] <= survivor_trade[:survivor].send(resource[:name])
            return { status: 'error', message: "#{survivor_trade[:survivor].name} doesn't have enough #{resource[:name]}"}
          end
        end

        { status: 'valid' }
      end

      def check_points
        [@survivor_trade_0, @survivor_trade_1].each do |survivor_trade|
          survivor_trade[:points] = 0
          Survivor::RESOURCES.each do |resource|
            survivor_trade[:points] += survivor_trade[resource[:name]] * resource[:points]
          end
        end

        return { status: 'valid' } if @survivor_trade_0[:points] == @survivor_trade_1[:points]
        { status: 'error', message: "Points doesn't match for the trade"}
      end

      def perform_trade
        survivor_0 = @survivor_trade_0[:survivor]
        survivor_1 = @survivor_trade_1[:survivor]

        Survivor::RESOURCES.each do |resource|
          # Survivor 0
          new_value_for_resource = survivor_0.send(resource[:name]) - @survivor_trade_0[resource[:name]] + @survivor_trade_1[resource[:name]]
          survivor_0.update(resource[:name] => new_value_for_resource)

          # Survivor 1
          new_value_for_resource = survivor_1.send(resource[:name]) + @survivor_trade_0[resource[:name]] - @survivor_trade_1[resource[:name]]
          survivor_1.update(resource[:name] => new_value_for_resource)
        end
      end
    end
  end
end
