Rails.application.routes.draw do
  databases = ["items", "merchants", "customers", "invoices", "transactions", "invoice_items"]
  
  namespace :api do
    namespace :v1 do
      
      databases.each do |database|
        get "#{database}/random", to: "#{database}#random", as: "random_#{database}"
        get "#{database}/find", to: "#{database}#find", as: "find_#{database}"
        get "#{database}/find_all", to: "#{database}#find_all", as: "find_all_#{database}"
      end
      
      get "merchants/most_revenue", to: "merchants#most_revenue", as: "merchant_most_revenue"
      get "merchants/most_items", to: "merchants#most_items", as: "merchant_most_items"
      get "merchants/revenue", to: "merchants#revenue", as: "merchant_revenue"

      get "merchants/:id/items", to: "merchants#items", as: "merchant_items"
      get "merchants/:id/invoices", to: "merchants#invoices", as: "merchant_invoices"
      get "merchants/:id/revenue", to: "merchants#revenue", as: "merchant_revenue"
      get "merchants/:id/favorite_customer", to: "merchants#favorite_customer", as: "merchant_favorite_customer"
      get "merchants/:id/customers_with_pending_invoices", to: "merchants#customers_with_pending_invoices", as: "merchant_customers_with_pending_invoices"
      
      get "invoices/:id/transactions", to: "invoices#transactions", as: "invoice_transactions"
      get "invoices/:id/invoice_items", to: "invoices#invoice_items", as: "invoice_invoice_items"
      get "invoices/:id/items", to: "invoices#items", as: "invoices_items"
      get "invoices/:id/customer", to: "invoices#customer", as: "invoices_customer"
      get "invoices/:id/merchant", to: "invoices#merchant", as: "invoices_merchant"

      get "invoice_items/:id/invoice", to: "invoice_items#invoice", as: "invoice_item_invoice"
      get "invoice_items/:id/item", to: "invoice_items#item", as: "invoice_item_item"
      
      get "items/:id/invoice_items", to: "items#invoice_items", as: "item_invoice_items"
      get "items/:id/merchant", to: "items#merchant", as: "item_merchant"
      
      get "transactions/:id/invoice", to: "transactions#invoice", as: "transaction_invoice"
      
      get "customers/:id/invoices", to: "customers#invoices", as: "customer_invoices"
      get "customers/:id/transactions", to: "customers#transactions", as: "customer_transactions"

      resources :items, only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :transactions, only: [:index, :show]


    end
  end

end



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
