class ModelErrorsSerializer < ActiveModel::Serializer
  attributes :errors

  def errors
    object.errors.to_h
  end
end
