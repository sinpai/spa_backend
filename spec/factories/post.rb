FactoryGirl.define do
  factory :post do
    title { FFaker::Lorem.words(3).join(' ') }
    body { FFaker::Lorem.words(10).join(' ') }
    username { FFaker::Internet.user_name }
  end
end
