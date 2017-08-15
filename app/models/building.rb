class Building < ApplicationRecord
  before_save :default_values

  has_many :rooms

  def default_values
    self.min_floor ||= -2
    self.max_floor ||= 10
  end
end
