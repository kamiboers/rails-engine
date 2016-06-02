class ChangeCcNumberOnTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :cc_number, :credit_card_number
  end
end
