class Task < ApplicationRecord
  # relation
  belongs_to :user

  # validation
  validates :title,
            presence: true,
            length: { maximum: 20 }
end
