class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :status
      t.integer :customer_id
      t.integer :merchant_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
