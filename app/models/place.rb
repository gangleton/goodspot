class Place < ActiveRecord::Base
  scope :wifi, -> { where(category: 'Wifi') }
  scope :hang, -> { where(category: 'Hang') }
  scope :sleep, -> { where(category: 'Sleep') }

  geocoded_by :address
  before_save :geocode

  def self.localize(text_location)
    unless text_location.match(/SF|San Francisco/)
      text_location.concat(", San Francisco")
    end
    return text_location
  end
end
