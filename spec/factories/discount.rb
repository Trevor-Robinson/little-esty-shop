FactoryBot.define do
  factory :discount do
    sequence(:quantity) {|n| n + 10 }
    sequence(:percentage) {|n| n + 15 }
  end
end
