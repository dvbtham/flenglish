FactoryBot.define do
  factory :category do
    name{Faker::Name.name}
  end

  factory :level do
    name{Faker::Name.name}
  end

  factory :movie do
    title_en{Faker::Lorem.sentence}
    title_vi{Faker::Lorem.sentence}
    description{Faker::Lorem.paragraph(10)}
    image_url{Settings.no_image}
    total_episodes{Faker::Number.between(1, 30)}
    is_feature{true}
    is_single{false}
    rating{Faker::Number.decimal(2)}
    views{Faker::Number.number(3)}
    association :category, factory: :category
    association :level, factory: :level
  end
end
