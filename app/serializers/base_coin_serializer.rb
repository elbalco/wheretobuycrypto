class BaseCoinSerializer < ActiveModel::Serializer
  attributes :id, :key, :name, :symbol
end
