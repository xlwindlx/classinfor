class Building < ApplicationRecord
  before_save :default_values

  has_many :rooms

  def default_values
    self.have_floors ||= 0
    self.valid_floors ||= 0
  end
end
