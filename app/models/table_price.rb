class TablePrice < ApplicationRecord
  validates :cadence,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 },
    uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price_additional, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :lower_cadence, -> () { order('cadence asc').first }
  scope :upper_cadence, -> () { order('cadence desc').first }

  def self.nearest_cadence(duration)
    table_prices = where('cadence >= ?', duration)
      .order('cadence asc')
      .first

    return upper_cadence if table_prices.blank?

    table_prices
  end
end
