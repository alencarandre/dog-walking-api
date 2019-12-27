class DogWalkingService::Filter < ApplicationService
  attr_reader :dog_walking, :params

  def initialize(dog_walking, params)
    @dog_walking = dog_walking
    @params = params
  end

  def call
    filtered_dog_walking = dog_walking
      .joins(pets: :dog_breed)
      .includes(pets: :dog_breed)

    filtered_dog_walking = upcoming_filter(dog_walking) if params[:upcoming].present?

    filtered_dog_walking.all
  end

  private

  def upcoming_filter(dog_walking)
    dog_walking
      .scheduled_higher_or_equal(Time.zone.now)
      .by_status([:scheduled])
  end
end
