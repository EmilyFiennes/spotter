class Event < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
  validates :activity, presence: true
  # validates :user, presence: true
  validates :address, presence: true
  # validates :max_participants, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  after_create :assign_participation


  def assign_participation
    Participation.create(user: self.user, event: self)
  end

end
