module Admin::MoviesHelper
  def link_to_add_episodes name, f, association
    object = f.object.send(association).klass.new
    id = object.object_id
    fields = f.fields_for(association, object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to name, "#", class: "add_episodes",
      data: {id: id, fields: fields.gsub("\n", "")}
  end
end
