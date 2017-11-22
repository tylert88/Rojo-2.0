class Parking < ApplicationRecord
  belongs_to :user
  has_many :photos

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :space_type, presence: true
  validates :parking_type, presence: true
  validates :accommodate, presence: true
  validates :parking_spot, presence: true
  validates :parking_avail, presence: true

  def cover_photo(size)
    if self.photos.length > 0
      self.photos[0].image.url(size)
    else
      "blank.jpg"
    end
  end
end
