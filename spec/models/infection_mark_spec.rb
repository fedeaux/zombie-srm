require 'rails_helper'

RSpec.describe InfectionMark, type: :model do
  let(:survivor) { create :survivor }
  let(:survivor2) { create :survivor }
  let(:survivor3) { create :survivor }
  let(:survivor4) { create :survivor }
  let(:infected) { create :survivor, :infected }

  it 'has a valid factory' do
    expect(create :infection_mark).to be_valid
  end

  context 'marking a survivor as infected' do
    it "One mark won't mark the survivor as infected", :aggregate_failures do
      expect(create :infection_mark, from: survivor2, to: survivor).to be_valid
      expect(survivor.reload).not_to be_infected
    end

    it "Two marks won't mark the survivor as infected", :aggregate_failures do
      expect(create :infection_mark, from: survivor2, to: survivor).to be_valid
      expect(create :infection_mark, from: survivor3, to: survivor).to be_valid
      expect(survivor.reload).not_to be_infected
    end

    it "Three marks marks the survivor as infected", :aggregate_failures do
      expect(create :infection_mark, from: survivor2, to: survivor).to be_valid
      expect(create :infection_mark, from: survivor3, to: survivor).to be_valid
      expect(create :infection_mark, from: survivor4, to: survivor).to be_valid
      survivor.reload
      expect(survivor).to be_infected
    end
end

  context 'validations' do
    it "can't be created from a survivor to itself" do
      survivor = create :survivor
      expect(build :infection_mark, from: survivor, to: survivor).not_to be_valid
    end

    it "can't be created twice for the same pair" do
      expect(create :infection_mark, from: survivor, to: survivor2).to be_valid
      expect(build :infection_mark, from: survivor, to: survivor2).not_to be_valid
    end
  end
end
