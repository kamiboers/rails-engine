class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.decimal :unit_price, precision: 8, scale: 2
      t.integer :merchant_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
