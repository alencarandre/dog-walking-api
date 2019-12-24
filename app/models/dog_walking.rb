class DogWalking < ApplicationRecord
  include AASM
  extend Enumerize

  STATUSES = %i(scheduled walking finished)

  has_many :dog_walking_dogs
  has_many :pets, through: :dog_walking_dogs, source: :dog

  validates :pets, presence: true
  validates :scheduled_at, presence: true
  validates :duration, presence: true
  validates :price, presence: true
  validates :final_price, presence: true, if: -> { status == :finished }

  enumerize :status, in: STATUSES

  scope :by_status, -> (*status) { where(status: status) }
  scope :scheduled_higher_or_equal, -> (date) { where('scheduled_at >= ?', date) }

  aasm column: :status do
    state :scheduled, initial: true
    state :walking
    state :finished

    event :start_walking do
      after { self.update(started_at: Time.zone.now) }

      transitions from: :scheduled, to: :walking
    end

    event :finish_walking do
      after { self.update(finished_at: Time.zone.now) }

      transitions from: :walking, to: :finished
    end
  end
end
