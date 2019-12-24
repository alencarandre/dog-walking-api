class DogWalkingService::Creator < ApplicationService
  attr_reader :dog_walking, :params

  def initialize(dog_walking, params)
    @dog_walking = dog_walking
    @params = params
  end

  def call
    dog_walking.create(dog_walking_params)
  end

  private

  def dog_walking_params
    params.merge(
      status: :scheduled,
      price: price
    )
  end

  def price
    return 0 if params[:pet_ids].blank? || params[:duration].blank?

    DogWalkingService::PriceCalculator.(
      duration: params[:duration].to_i,
      pets: params[:pet_ids].length
    )
  end
end
