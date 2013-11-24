class PhoneNumber < ActiveRecord::Base
  belongs_to :user
  has_many :response_sequences

end
