class Channel < ApplicationRecord

  belongs_to :group

  enum status: { unchecked: 0, active: 1, suspended: 2, archived: 3 }

  validates :url, :name, :status, presence: true
  validates :url, uniqueness: true
end
