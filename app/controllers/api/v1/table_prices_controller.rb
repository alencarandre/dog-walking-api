class Api::V1::TablePricesController < ApplicationController
  def index
    render json: TablePrice.all, each_serializer: TablePriceSerializer
  end
end
