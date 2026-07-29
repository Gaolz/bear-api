class Run < ApplicationRecord
  belongs_to :user

  validates :date, presence: true, uniqueness: { scope: :user_id }
  validates :distance, presence: true, numericality: { greater_than: 0 }
end
