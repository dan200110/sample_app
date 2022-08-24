class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id
end
