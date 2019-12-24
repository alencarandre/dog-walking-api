class DogWalkingSerializer < ActiveModel::Serializer
  attributes :id, :status, :duration, :price, :scheduled_at,
    :started_at, :finished_at, :pets

  def pets
    object.pets.length
  end

  def object
    super.decorate
  end
end
