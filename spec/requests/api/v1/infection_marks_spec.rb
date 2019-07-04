require 'rails_helper'

RSpec.describe 'api/v1/infection_marks', type: :request do
  let(:survivors) { create_list :survivor, 4 }

  describe 'POST /api/v1/infection_marks' do
    it 'creates a new infection mark', :aggregate_failures do
      expect {
        post api_v1_infection_marks_path(format: :json),
             params: { infection_mark: { from_id: survivors.first.id, to_id: survivors.second.id }}
      }.to change{ InfectionMark.count }.from(0).to(1)

      expect(response).to be_successful

      infection_mark = InfectionMark.first

      expect(infection_mark.from_id).to eq survivors.first.id
      expect(infection_mark.to_id).to eq survivors.second.id
    end

    it 'creates marks the target as infected on three marks created to it', :aggregate_failures do
      post api_v1_infection_marks_path(format: :json),
           params: { infection_mark: { from_id: survivors.second.id, to_id: survivors.first.id }}

      expect(response).to be_successful

      expect(survivors.first.reload).not_to be_infected

      post api_v1_infection_marks_path(format: :json),
           params: { infection_mark: { from_id: survivors.third.id, to_id: survivors.first.id }}

      expect(response).to be_successful

      expect(survivors.first.reload).not_to be_infected

      post api_v1_infection_marks_path(format: :json),
           params: { infection_mark: { from_id: survivors.fourth.id, to_id: survivors.first.id }}

      expect(response).to be_successful

      expect(survivors.first.reload).to be_infected
    end
  end
end
