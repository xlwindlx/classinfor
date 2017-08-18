class Lecture < ApplicationRecord
  # belongs_to :major
  has_many :time_classes
end
