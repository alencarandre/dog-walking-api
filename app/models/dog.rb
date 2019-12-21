class Dog < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :dog_breed, presence: true
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :dog_breed

  scope :dog_breed_eager, -> {
    joins(:dog_breed)
    .includes(:dog_breed)
  }
end
