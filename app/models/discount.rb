class Discount < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :percentage

  belongs_to :merchant
end
