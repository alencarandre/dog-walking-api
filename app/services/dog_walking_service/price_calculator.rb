class DogWalkingService::PriceCalculator < ApplicationService
  def initialize(duration:, pets:)
    @duration = duration
    @additional_pets = pets -1
  end

  def call
    return 0 if @additional_pets < 0

    price = calculate(@duration, table_price.price, 1)
    price += calculate(@duration, table_price.price_additional, @additional_pets) if @additional_pets > 0

    price.round(2)
  end

  private

  def calculate(duration, price, pets)
    return price * pets if duration <= lower_cadence

    duration_in_hours = (duration / table_price.cadence.to_f)
    (price * duration_in_hours * pets)
  end

  def table_price
    @table_price ||= TablePrice.nearest_cadence(@duration)
  end

  def lower_cadence
    @lower_cadence ||= TablePrice.lower_cadence.cadence
  end
end
