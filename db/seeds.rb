Category.create! name: I18n.t("genre.single")
Category.create! name: I18n.t("genre.series")

5.times do |n|
  Genre.create! name: Faker::Book.genre
end

3.times do |n|
  Level.create! name: "#{I18n.t("level")} #{n + 1}"
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

10.times do |n|
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

20.times do |n|
  image_slug = Faker::Lorem.word
  category_id = Faker::Number.between(1, 2)
  Movie.create!(title_en: Faker::Lorem.sentence,
                title_vi: Faker::Lorem.sentence,
                description: Faker::Lorem.paragraph(10),
                image_url: Faker::Avatar.image(image_slug),
                category_id: category_id,
                level_id: Faker::Number.between(1, 3),
                total_episodes: Faker::Number.between(1, 30),
                is_feature: n%2 == 0 ? true : false,
                is_single: n%2 == 0 ? true : false,
                rating: Faker::Number.decimal(2),
                views: Faker::Number.number(3))
end

# Seed data to genres_movies table
movies = Movie.all
movies.each do |movie|
  movie.genres << Genre.find_or_create_by(id: Faker::Number.between(1, 5))
  movie.update_attribute :total_episodes, 1 if movie.is_single?
  movie.total_episodes.times do |index|
    movie.episodes.create(name: "#{index + 1}",
      video_url: "https://www.youtube.com/embed/tLNOce4Y4uc")
  end
end

# Add subtitles for each episodes
episodes = Episode.all
episodes.each do |episode|
  10.times do
    episode.subtitles.create!(vietsub: Faker::Lorem.sentence,
                              engsub: Faker::Lorem.sentence,
                              subtitle_at: Faker::Number.between(0, 180))
  end
end

# Following relationships
users = User.all
user  = users.first
following = users[3..8]
followers = users[1..10]
following.each {|followed| user.follow followed}
followers.each {|follower| follower.follow user}
