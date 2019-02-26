FactoryBot.define do
  factory :user do
    full_name{Faker::Name.name}
    email{Faker::Internet.email}
    gender{0}
    date_of_birth{Faker::Date.birthday(16, 60)}
    password{"password"}
    password_confirmation{"password"}
  end
end
