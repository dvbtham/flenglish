# require "shoulda/matchers"
require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid user" do
    expect(build(:user)).to be_valid
  end

  describe "associations" do
    it "has many active relationships" do
      is_expected.to have_many(:active_relationships).dependent :destroy
    end

    it "has many passive relationships" do
      is_expected.to have_many(:passive_relationships).dependent :destroy
    end

    it "has many following" do
      is_expected.to have_many(:following).through(:active_relationships)
        .source :followed
    end

    it "has many followers" do
      is_expected.to have_many(:followers).through(:passive_relationships)
        .source :follower
    end

    it "has many suggests" do
      is_expected.to have_many :suggests
    end

    it "has many favorited movies" do
      is_expected.to have_many(:favorited_movies).dependent :destroy
    end

    it "has many favorited movies" do
      is_expected.to have_many(:favorited_movies).dependent :destroy
    end

    it "has many favoriting movies" do
      is_expected.to have_many(:favoriting).through(:favorited_movies)
        .source :movie
    end

    it "has many movies following" do
      is_expected.to have_many(:movie_followings).dependent :destroy
    end

    it "has many followed movies" do
      is_expected.to have_many(:followed_movies).through(:movie_followings)
        .source :movie
    end

    it "has many rating movies" do
      is_expected.to have_many(:rating_movies).dependent :destroy
    end

    it "has many rated movies" do
      is_expected.to have_many(:rated_movies).through(:rating_movies)
        .source :movie
    end

    it "has many comments" do
      is_expected.to have_many(:comments).dependent :destroy
    end

    it "has many user movies" do
      is_expected.to have_many(:user_movies).dependent :destroy
    end

    it "has many watched movies" do
      is_expected.to have_many(:watched_movies).through(:user_movies)
        .source :movie
    end

    it "has many movie vocabularies" do
      is_expected.to have_many(:movie_vocabularies).dependent :destroy
    end

    it "has many vocabularies" do
      is_expected.to have_many(:vocabularies).through(:movie_vocabularies)
        .source :dictionary
    end

    it "has many notifications" do
      is_expected.to have_many :notifications
    end
  end

  describe "gender's enumeration" do
    it "should be either male or female" do
      is_expected.to define_enum_for(:gender)
        .with_values %i(male female)
    end
  end

  describe "role's enumeration" do
    it "should be either member or administrator" do
      is_expected.to define_enum_for(:role).with_values %i(member administrator)
    end
  end

  context "when validates" do
    let(:user){FactoryBot.create :user}
    let(:not_blank){I18n.t "rspec.error_messages.blank"}
    describe "full name" do
      it{is_expected.to validate_presence_of :full_name}
      it{is_expected.to validate_length_of(:full_name).is_at_most 50}
      it "can't be blank" do
        user.full_name = nil
        user.valid?
        expect(user.errors.messages[:full_name].first).to eq not_blank
      end

      it "is too long" do
        user.full_name = Faker::Lorem.characters 60
        user.valid?
        expect(user.errors.messages[:full_name].first).to eq(
          I18n.t "rspec.error_messages.max_length", count: 50)
      end
    end

    describe "date of birth" do
      it{is_expected.to validate_presence_of :date_of_birth}
      it "can't be blank" do
        user.date_of_birth = nil
        user.valid?
        expect(user.errors.messages[:date_of_birth].first).to eq not_blank
      end
    end

    describe "gender" do
      it{is_expected.to validate_presence_of :gender}
      it "can't be blank" do
        user.gender = nil
        user.valid?
        expect(user.errors.messages[:gender].first).to eq not_blank
      end
    end
  end

  describe "#follow" do
    let(:user){FactoryBot.create :user}
    let(:another_user){FactoryBot.create :user}
    it "returns 1 following" do
      user.follow another_user
      expect(user.following.size).to eq 1
    end
  end
end
