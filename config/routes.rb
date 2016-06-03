Rails.application.routes.draw do
  databases = ["items", "merchants", "customers", "invoices", "transactions", "invoice_items"]
  
  namespace :api do
    namespace :v1 do
      
      databases.each do |database|
        get "#{database}/random", to: "#{database}#random", as: "random_#{database}"
        get "#{database}/find", to: "#{database}#find", as: "find_#{database}"
        get "#{database}/find_all", to: "#{database}#find_all", as: "find_all_#{database}"
      end
      
      get "merchants/most_revenue", to: "merchants#most_revenue", as: "merchants_most_revenue"
      get "merchants/most_items", to: "merchants#most_items", as: "merchants_most_items"
      get "merchants/revenue", to: "merchants#all_revenue", as: "merchants_revenue"

      get "merchants/:id/items", to: "merchants#items", as: "merchant_items"
      get "merchants/:id/invoices", to: "merchants#invoices", as: "merchant_invoices"
      get "merchants/:id/revenue", to: "merchants#revenue", as: "merchant_revenue"
      get "merchants/:id/favorite_customer", to: "merchants#favorite_customer", as: "merchant_favorite_customer"
      get "merchants/:id/customers_with_pending_invoices", to: "merchants#customers_with_pending_invoices", as: "merchant_pending_customers"
      
      get "invoices/:id/transactions", to: "invoices#transactions", as: "invoice_transactions"
      get "invoices/:id/invoice_items", to: "invoices#invoice_items", as: "invoice_invoice_items"
      get "invoices/:id/items", to: "invoices#items", as: "invoices_items"
      get "invoices/:id/customer", to: "invoices#customer", as: "invoices_customer"
      get "invoices/:id/merchant", to: "invoices#merchant", as: "invoices_merchant"

      get "invoice_items/:id/invoice", to: "invoice_items#invoice", as: "invoice_item_invoice"
      get "invoice_items/:id/item", to: "invoice_items#item", as: "invoice_item_item"
      
      get "items/most_revenue", to: "items#most_revenue", as: "items_most_revenue"
      get "items/most_items", to: "items#most_items", as: "items_most_items"

      get "items/:id/invoice_items", to: "items#invoice_items", as: "item_invoice_items"
      get "items/:id/merchant", to: "items#merchant", as: "item_merchant"
      get "items/:id/best_day", to: "items#best_day", as: "item_best_day"
      
      get "transactions/:id/invoice", to: "transactions#invoice", as: "transaction_invoice"
      
      get "customers/:id/invoices", to: "customers#invoices", as: "customer_invoices"
      get "customers/:id/transactions", to: "customers#transactions", as: "customer_transactions"
      get "customers/:id/favorite_merchant", to: "customers#favorite_merchant", as: "customer_favorite_merchant"

      resources :items, only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end