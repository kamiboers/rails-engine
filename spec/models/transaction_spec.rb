require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should validate_presence_of :cc_number }
  it { should validate_presence_of :result }
  it { should validate_presence_of :invoice_id }
end
