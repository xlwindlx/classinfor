class Room < ApplicationRecord
  belongs_to :building
  belongs_to :department, optional: true
  has_many :comments
  has_many :time_classes

  before_save :default_value
  def default_value
    self.level ||= 3
  end

  after_save :floor_update
  def floor_update
    new_floors = self.building.have_floors | (1 << (self.floor + 6))

    self.building.update_column(:have_floors, new_floors)
    self.building.update_column(:valid_floors, new_floors) if self.level < 2
  end
end
