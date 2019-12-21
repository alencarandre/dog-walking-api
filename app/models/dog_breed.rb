class DogBreed < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }

  has_one :dog
end
