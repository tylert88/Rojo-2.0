class Parking < ApplicationRecord
  belongs_to :user
  has_many :photos

  validates :space_type, presence: true
  validates :parking_type, presence: true
  validates :accommodate, presence: true
  validates :parking_spot, presence: true
  validates :parking_avail, presence: true
end
