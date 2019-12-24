class DogWalkingService::Finisher < ApplicationService
  def initialize(dog_walking_model, params)
    @dog_walking = dog_walking_model.find(params[:id])
  end

  def call
    finish_walking

    @dog_walking
  end

  private

  def finish_walking
    @dog_walking.finish_walking
    @dog_walking.final_price = price
    @dog_walking.save!
  rescue AASM::InvalidTransition => e
    @dog_walking.errors.add(:status, e.message)
  end

  def price
    DogWalkingService::PriceCalculator.(
      duration: @dog_walking.decorate.real_duration,
      pets: @dog_walking.pets.length
    )
  end
end
