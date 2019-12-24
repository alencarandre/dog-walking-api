class DogWalkingService::Starter < ApplicationService
  def initialize(dog_walking_model, params)
    @dog_walking = dog_walking_model.find(params[:id])
  end

  def call
    start_walking

    @dog_walking
  end

  private

  def start_walking
    @dog_walking.start_walking!
  rescue AASM::InvalidTransition => e
    @dog_walking.errors.add(:status, e.message)
  end
end
