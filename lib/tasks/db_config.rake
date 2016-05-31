require 'net/http'
require 'csv'

namespace :databases do
  desc "Rake tasks to fetch data"
  task :fetch do 
    databases = ["merchants", "customers", "invoice_items", "invoices", "items", "items", "transactions"]
    databases.each do |data_subset|
      uri = URI("https://raw.githubusercontent.com/turingschool-examples/sales_engine/master/data/#{data_subset}.csv")
      downloaded_file = Net::HTTP.get(uri)

      File.open(Rails.root.join('lib', 'assets', "#{data_subset}.csv"), 'w') do |file|
        file.write(downloaded_file)
      end
    end
  end

  desc "Process merchants file"
  task :create_merchants => :environment do
    csv_file = Rails.root.join('lib', 'assets', 'merchants.csv')
    CSV.foreach(csv_file, {col_sep: ",", quote_char: '&', headers: true, header_converters: :symbol}) do |row|
      merchant = Merchant.create do |m|
        m.name = row[:name]
        m.created_at = row[:created_at]
        m.updated_at = row[:updated_at]
      end
    end
  end


  desc "Process customers file"
  task :create_customers => :environment do
    csv_file = Rails.root.join('lib', 'assets', 'customers.csv')
    CSV.foreach(csv_file, {col_sep: ",", quote_char: '&', headers: true, header_converters: :symbol}) do |row|
      customer = Customer.create do |c|
        c.first_name = row[:first_name]
        c.last_name = row[:last_name]
        c.created_at = row[:created_at]
        c.updated_at = row[:updated_at]
      end
    end
  end


  desc "Process items file"
  task :create_items => :environment do
    csv_file = Rails.root.join('lib', 'assets', 'items.csv')
    CSV.foreach(csv_file, {col_sep: ",", quote_char: '&', headers: true, header_converters: :symbol}) do |row|
      item = Item.create do |i|
        i.name = row[:name]
        i.description = row[:description]
        i.unit_price = (row[:unit_price].to_f/100)
        i.merchant_id = row[:merchant_id]
        i.created_at = row[:created_at]
        i.updated_at = row[:updated_at]
      end
    end
  end

  desc "Process invoices file"
  task :create_invoices => :environment do
    csv_file = Rails.root.join('lib', 'assets', 'invoices.csv')
    CSV.foreach(csv_file, {col_sep: ",", quote_char: '&', headers: true, header_converters: :symbol}) do |row|
      invoice = Invoice.create do |i|
        i.customer_id = row[:customer_id]
        i.merchant_id = row[:merchant_id]
        i.status = row[:status]
        i.created_at = row[:created_at]
        i.updated_at = row[:updated_at]
      end
    end
  end

  desc "Process transactions file"
  task :create_transactions => :environment do
    csv_file = Rails.root.join('lib', 'assets', 'transactions.csv')
    CSV.foreach(csv_file, {col_sep: ",", quote_char: '&', headers: true, header_converters: :symbol}) do |row|
      transaction = Transaction.create do |t|
        t.invoice_id = row[:invoice_id]
        t.cc_number = row[:credit_card_number]
        t.expiration = row[:credit_card_expiration_date]
        t.result = row[:result]
        t.created_at = row[:created_at]
        t.updated_at = row[:updated_at]
      end
    end
  end

  desc "Process invoice items file"
  task :create_invoice_items => :environment do
    csv_file = Rails.root.join('lib', 'assets', 'invoice_items.csv')
    CSV.foreach(csv_file, {col_sep: ",", quote_char: '&', headers: true, header_converters: :symbol}) do |row|
      invoice_item = InvoiceItem.create do |ii|
        ii.item_id = row[:item_id]
        ii.invoice_id = row[:invoice_id]
        ii.quantity = row[:quantity]
        ii.unit_price = (row[:unit_price].to_f/100)
        ii.created_at = row[:created_at]
        ii.updated_at = row[:updated_at]
      end
    end
  end

end