class Reagent < ActiveRecord::Base

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true

end