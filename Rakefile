# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :default => 'databases:fetch'
task :default => 'databases:create_customers'
task :default => 'databases:create_merchants'
task :default => 'databases:create_items'
task :default => 'databases:create_invoices'
task :default => 'databases:create_invoice_items'
task :default => 'databases:create_transactions'

# Rake::Task["databases:fetch"].execute
# Rake::Task["databases:create_customers"].execute
# Rake::Task["databases:create_merchants"].execute
# Rake::Task["databases:create_items"].execute
# Rake::Task["databases:create_invoices"].execute
# Rake::Task["databases:create_invoice_items"].execute
# Rake::Task["databases:create_transactions"].execute