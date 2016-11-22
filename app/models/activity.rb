class Activity < ApplicationRecord
  has_many :events
  validates :name, presence: true
  default_scope -> { order(name: :ASC) }
end
