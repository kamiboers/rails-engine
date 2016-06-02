class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :merchant_id
  attribute :display_price, key: :unit_price

  def display_price
    (object.unit_price/100.0).to_s
  end

end
