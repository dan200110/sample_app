module ApplicationHelper
  def full_title page_title
    base_title = I18n.t :page_title
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end
end
