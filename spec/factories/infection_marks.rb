FactoryBot.define do
  factory :infection_mark do
    from { create :survivor }
    to { create :survivor }
  end
end
