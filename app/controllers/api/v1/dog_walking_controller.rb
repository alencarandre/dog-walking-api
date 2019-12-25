class Api::V1::DogWalkingController < ApplicationController
  # GET /api/v1/dog_walking
  def index
    dog_walkings = DogWalkingService::Filter.(DogWalking, params)

    render json: dog_walkings, each_serializer: DogWalkingSerializer
  end

  # GET /api/v1/dog_walking/:id
  def show
    dog_walking = DogWalkingService::Finder.(DogWalking, params)

    render json: dog_walking, serializer: DogWalkingSerializer
  end

  # POST /api/v1/dog_walking
  def create
    dog_walking = DogWalkingService::Creator.(DogWalking, dog_walking_params)

    if dog_walking.valid?
      render json: dog_walking, status: :created, serializer: DogWalkingSerializer
    else
      render json: dog_walking, status: :conflict, serializer: ModelErrorsSerializer
    end
  end

  # PATCH /api/v1/dog_walking/:id/start_walking
  def start_walking
    dog_walking = DogWalkingService::Starter.(DogWalking, params)

    if dog_walking.errors.present?
      render json: dog_walking, status: :conflict, serializer: ModelErrorsSerializer
    else
      render json: dog_walking, serializer: DogWalkingSerializer
    end
  end

  # PATCH /api/v1/dog_walking/:id/finish_walking
  def finish_walking
    dog_walking = DogWalkingService::Finisher.(DogWalking, params)

    if dog_walking.errors.present?
      render json: dog_walking, status: :conflict, serializer: ModelErrorsSerializer
    else
      render json: dog_walking, serializer: DogWalkingSerializer
    end
  end

  private

  def dog_walking_params
    params
      .require(:dog_walking)
      .permit(:latitude, :longitude, :duration, :scheduled_at, pet_ids: [])
  end
end
