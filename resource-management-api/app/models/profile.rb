class Profile < ApplicationRecord
  belongs_to :organization
  belongs_to :workgroup
  has_and_belongs_to_many :users

  validates :organization, presence: true
  validates :workgroup, presence: true
end