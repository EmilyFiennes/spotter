class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :events
  has_many :participations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true
end
