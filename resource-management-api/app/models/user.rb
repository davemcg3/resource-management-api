class User < ApplicationRecord
  has_secure_password # validates password presence implicitly

  validates :email, uniqueness: true
  validates :email, presence: true
end
