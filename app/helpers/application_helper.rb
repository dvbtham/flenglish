module ApplicationHelper
  def full_title page_title
    base_title = I18n.t("app_name")

    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def summary content, size
    content.length <= size ? content : truncate(content, length: size)
  end
end
