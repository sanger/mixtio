module ApplicationHelper
  ##
  # Current year necessary for copyright.
  def current_year
    @current_year ||= Date.today.year
  end

  def cp(path)
    "current" if request.url.include?(path)
  end

end
