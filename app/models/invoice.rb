class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: [ "in progress", "cancelled", "completed" ]

  def self.incomplete_invoices
    joins(:invoice_items)
    .where('invoice_items.status != ?', 2)
    .select('invoices.*, invoice_items.invoice_id AS invoice_id, invoices.created_at AS invoice_created_at')
    .order('invoice_created_at')
    .distinct
  end

  def total_revenue
    invoice_items.sum("invoice_items.quantity * invoice_items.unit_price").to_i
  end

  def discount_items
    invoice_items
    .joins(:discounts)
    .where('invoice_items.quantity >= discounts.quantity')
    .select('invoice_items.*, discounts.id as discount_id, max(discounts.quantity) as discount_quantity ,max(discounts.percentage) as discount_percentage')
    .group('invoice_items.id, discounts.id')
    .order('discount_quantity DESC')
  end

  def discount_amounts
    invoice_items.joins(:discounts).where('invoice_items.quantity >= discounts.quantity').select('invoice_items.*, ((max(discounts.percentage)/100) * (invoice_items.quantity * invoice_items.unit_price)) as discount_amount').group('invoice_items.id').order('discount_amount DESC')
  end

  def total_discount
    total = discount_amounts.sum{ |amount| amount.discount_amount}.to_i
  end

  def final_revenue
    total_revenue - total_discount
  end
end
