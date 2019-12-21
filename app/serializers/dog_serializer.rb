class DogSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :dog_breed

  belongs_to :dog_breed
end
