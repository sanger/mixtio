module ApplicationHelper
  ##
  # Current year necessary for copyright.
  def current_year
    @current_year ||= Date.today.year
  end

  def cp(path)
    "current" if current_page?(path)
  end

  def near_christmas?
    Date.today > Date.parse(Rails.configuration.snow_start) && Date.today < Date.parse(Rails.configuration.snow_end)
  end

end
