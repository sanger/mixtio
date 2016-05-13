module HasVolume

  extend ActiveSupport::Concern

  included do
    enum unit: {
        "µL": -6,
        "mL": -3,
        'L': 0,
    }
  end

  def display_volume
    if volume
      i, f = volume.to_i, volume.to_f
      "#{i == f ? i : f}#{unit}"
    else
      nil
    end
  end

end