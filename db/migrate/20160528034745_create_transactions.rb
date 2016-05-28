class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :cc_number
      t.string :expiration
      t.string :result
      t.integer :invoice_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
