FactoryBot.define do
  factory :run do
    association :user
    date { Date.current }
    distance { 5.0 }
    done { false }
  end
end
