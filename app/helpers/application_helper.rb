module ApplicationHelper
  include DateHelper

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

  def active_episode episode_id, param
    episode_id.to_s == param ? :info : :default
  end

  def active_tab tab_name
    return :active if params[:tab] == tab_name.to_s
  end
end
