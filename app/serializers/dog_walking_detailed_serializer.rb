class DogWalkingDetailedSerializer < ActiveModel::Serializer
  attributes :id, :status, :duration, :real_duration, :price, :final_price,
    :latitude, :longitude, :scheduled_at, :started_at, :finished_at, :pets

  has_many :pets, through: :dog_walking_dogs, source: :dog

  def object
    super.decorate
  end
end
