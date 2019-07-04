require 'rails_helper'

RSpec.describe 'api/v1/survivors', type: :request do
  let(:campinas_survivor_params) {{survivor: attributes_for(:survivor ) }}
  let(:jundiai_survivor_params) {{ survivor: attributes_for(:survivor, :from_jundiai ) }}
  let(:sao_paulo_survivor) { create(:survivor, :from_sao_paulo ) }

  describe 'POST /api/v1/survivors' do
    it 'creates a new survivor', :aggregate_failures do
      expect {
        post api_v1_survivors_path,
             params: campinas_survivor_params
      }.to change{ Survivor.count }.from(0).to(1)

      expect(response).to be_successful

      survivor = Survivor.first

      campinas_survivor_params[:survivor].each do |attribute, value|
        expect(survivor.send(attribute)).to eq value
      end
    end
  end

  describe 'PUT /api/v1/survivors/:id', :aggregate_failures do
    it 'update survivors latitude and longitude, ignores all other params (which are being passed on purpose)' do

      # this spec will just update latitude and longitude
      put api_v1_survivor_path(id: sao_paulo_survivor.id),
          params: jundiai_survivor_params

      expect(response).to be_successful

      sao_paulo_survivor.reload
      expect(sao_paulo_survivor.latitude).to eq jundiai_survivor_params[:survivor][:latitude]
      expect(sao_paulo_survivor.longitude).to eq jundiai_survivor_params[:survivor][:longitude]
      expect(sao_paulo_survivor.name).not_to eq jundiai_survivor_params[:survivor][:name]
    end
  end
end
