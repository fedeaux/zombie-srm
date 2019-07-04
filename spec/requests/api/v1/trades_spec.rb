require 'rails_helper'

RSpec.describe 'api/v1/trades', type: :request do
  let(:campinas_survivor) { create(:survivor ) }
  let(:jundiai_survivor) { create(:survivor, :from_jundiai ) }
  let(:infected) { create(:survivor, :infected ) }

  describe 'POST /api/v1/trades' do
    it 'trades between two survivors', :aggregate_failures do
      trade_params = valid_trade_params(campinas_survivor, jundiai_survivor)

      post api_v1_trades_path,
           params: trade_params

      campinas_survivor.reload
      jundiai_survivor.reload

      # Assumes each survivor started with the same number of each resource
      Survivor::RESOURCES.each do |resource|
        difference = campinas_survivor.send(resource[:name]) - jundiai_survivor.send(resource[:name])
        # Finish this
      end
    end

    it "fails to trade with the infected" , :aggregate_failures do
      post api_v1_trades_path,
           params: valid_trade_params(campinas_survivor, infected)

      expect(JSON.parse(response.body)['message']).to eq "Can't trade with the infected"
    end

    it "fails to trade if one survivor doesn't have enough of what he's offering" , :aggregate_failures do
      post api_v1_trades_path,
           params: not_enough_trade_params(campinas_survivor, jundiai_survivor)

      expect(JSON.parse(response.body)['message']).to match /Campinas Survivor \d+ doesn't have enough water/
    end

    it "fails trades that doesn't have the same number of points for each side" , :aggregate_failures do
      post api_v1_trades_path,
           params: unbalanced_trade_params(campinas_survivor, jundiai_survivor)

      expect(JSON.parse(response.body)['message']).to eq "Points doesn't match for the trade"
    end
  end
end

def unbalanced_trade_params(survivor_0, survivor_1)
  {
    trade: [
      {
        survivor_id: survivor_0.id,
        water: 2
      },
      {
        survivor_id: survivor_1.id,
        food: 1,
        medication: 2,
        ammunition: 5
      }
    ]
  }
end

def not_enough_trade_params(survivor_0, survivor_1)
  {
    trade: [
      {
        survivor_id: survivor_0.id,
        water: survivor_0.water + 1
      },
      {
        survivor_id: survivor_1.id,
        food: 2,
        medication: 2,
        ammunition: 5
      }
    ]
  }
end

def valid_trade_params(survivor_0, survivor_1)
  {
    trade: [
      {
        survivor_id: survivor_0.id,
        water: 2
      },
      {
        survivor_id: survivor_1.id,
        food: 1,
        medication: 2,
        ammunition: 1
      }
    ]
  }
end
