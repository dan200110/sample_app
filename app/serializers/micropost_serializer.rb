class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :content, :employee_id
end
