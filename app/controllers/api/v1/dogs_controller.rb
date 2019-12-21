class Api::V1::DogsController < ApplicationController
  def index
    render json: Dog.dog_breed_eager, each_serializer: DogSerializer
  end
end
