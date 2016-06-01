class MerchantSerializer < ActiveModel::Serializer
  attributes :id, :name #, uppercase_name

  # has_many :items # will give body of subset items, etc
  # custom attributes 

  # def uppercase_name
  #   object.name.upcase # this functions like self in the model 
  # end


end
