class User < ApplicationRecord
  # validation
  validates :name,
            presence: true,
            length: { maximum: 20 }
  validates :email,
            presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }

  # relation
  has_many :tasks, dependent: :destroy
end
