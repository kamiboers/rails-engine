class Invoice < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  belongs_to :invoice_item
end
