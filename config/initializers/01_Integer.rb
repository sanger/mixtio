class Integer

  def days_from_today
    self.days.from_now.to_date.to_s(:uk)
  end

end