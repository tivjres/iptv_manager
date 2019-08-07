class ListItem < ApplicationRecord
  belongs_to :user
  belongs_to :list
  belongs_to :channel
end
