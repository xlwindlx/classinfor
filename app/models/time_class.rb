class TimeClass < ApplicationRecord
  belongs_to :lecture
  belongs_to :room, optional: true
end
