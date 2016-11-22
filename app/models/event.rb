class Event < ApplicationRecord
  #belongs_to :user
  belongs_to :activity
  has_many :participations
  validates :activity, presence: true
  validates :user, presence: true
  validates :address, presence: true
  validates :max_participants, presence: true
end
