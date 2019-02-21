require "digest"
module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar.size.user}
    md5 = Digest::MD5.new
    gravatar_id = md5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: "gravatar")
  end

  def has_vocabularies? movie_id
    current_user.saved_vocabularies(movie_id).any?
  end

  def has_follow_movie? movie
    @following = current_user.movie_followings.find_by movie_id: movie.id
    @following ? t(:unfollow) : t(:follow)
  end
end
