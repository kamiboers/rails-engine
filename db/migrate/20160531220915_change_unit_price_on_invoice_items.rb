class ChangeUnitPriceOnInvoiceItems < ActiveRecord::Migration
  def change
    change_column(:invoice_items, :unit_price, :integer)
  end
end
