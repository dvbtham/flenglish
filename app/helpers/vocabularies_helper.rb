module VocabulariesHelper
  def not_in_favorite? movie_id, dictionary_id
    vocabulary = current_user.movie_vocabularies.find_by movie_id: movie_id,
      dictionary_id: dictionary_id
    vocabulary.nil?
  end
end
