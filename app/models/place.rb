class Place < ActiveRecord::Base
  scope :wifi, -> { where(category: 'Wifi') }
  scope :hang, -> { where(category: 'Hang') }
  scope :sleep, -> { where(category: 'Sleep') }

end
