class DogWalkingService::Finder < ApplicationService
  attr_reader :dog_walking, :params

  def initialize(dog_walking, params)
    @dog_walking = dog_walking
    @params = params
  end

  def call
    dog_walking
      .joins(pets: :dog_breed)
      .includes(pets: :dog_breed)
      .find(params[:id])
  end
end
