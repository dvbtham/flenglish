seed = Settings.seed

Category.create! name: I18n.t("genre.single")
Category.create! name: I18n.t("genre.series")

5.times do |n|
  Genre.create! name: Faker::Book.genre
end

4.times do |n|
  Level.create! name: "Level #{n}"
end

User.create!(full_name: "Thâm Davies",
             email: "thamdv96@gmail.com",
             gender: User.genders[:male],
             date_of_birth: "1996-09-15",
             password: "123123",
             password_confirmation: "123123",
             role: 1,
             activated: true,
             activated_at: Time.zone.now)

20.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@flenglish.edu"
  password = "password"
  User.create!(full_name: name,
               email: email,
               gender: Faker::Number.between(0, 1),
               date_of_birth: Faker::Date.birthday(16, 60),
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

30.times do |n|
  image_slug = Faker::Lorem.word
  category_id = Faker::Number.between(1, 2)
  Movie.create!(title_en: Faker::Lorem.sentence,
                title_vi: Faker::Lorem.sentence,
                description: Faker::Lorem.paragraph(10),
                image_url: Faker::Avatar.image(image_slug),
                category_id: category_id,
                level_id: Faker::Number.between(1,4),
                total_episodes: Faker::Number.between(16, 30),
                is_feature: n%2 ? true : false,
                rating: Faker::Number.decimal(2),
                views: Faker::Number.number(3))
end

# Seed data to genres_movies table
movies = Movie.all
movies.each do |movie|
  movie.genres << Genre.find_or_create_by(id: Faker::Number.between(1, 5))
end
