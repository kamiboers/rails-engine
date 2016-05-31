class ChangeUnitPriceOnItems < ActiveRecord::Migration
  def change
    change_column(:items, :unit_price, :integer)
  end
end
