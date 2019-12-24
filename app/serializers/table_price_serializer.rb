class TablePriceSerializer < ActiveModel::Serializer
  attributes :id, :cadence, :price, :price_additional
end
