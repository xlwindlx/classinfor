class Lecture < ApplicationRecord
  # belongs_to :major
  has_many :time_classes
  belongs_to :room, optional: true
end
