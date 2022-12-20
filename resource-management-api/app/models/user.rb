class User < ApplicationRecord
  has_secure_password # validates password presence implicitly
  has_and_belongs_to_many :profiles

  validates :email, uniqueness: true
  validates :email, presence: true
end
