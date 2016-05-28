class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :quantity
      t.decimal :unit_price, precision: 8, scale: 2
      t.integer :item_id
      t.integer :invoice_id
      t.datetime :created_at
      t.datetime :updated_at
  end
end
end