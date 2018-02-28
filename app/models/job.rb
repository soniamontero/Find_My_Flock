class Job < ApplicationRecord
  has_many :applications
  has_many :favorites

  validates :title, presence: true
  validates :company, presence: true
  validates :description, presence: true
  validates :location, presence: true
end