class UserSerializer < ActiveModel::Serializer
  attributes :id, :wca_id, :name, :gender, :country_iso2, :delegate_status, :created_at, :updated_at

  attribute :avatar do
    {
      url: object.avatar.url,
      thumb_url: object.avatar.url(:thumb),
      is_default: !object.avatar?,
    }
  end

  has_many :teams

  link(:self) { api_v1_user_url object }
end
