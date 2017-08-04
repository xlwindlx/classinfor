class Room < ApplicationRecord
  belongs_to :building
  belongs_to :department
  has_many :comments
  has_many :time_classes
end
