class UserSerializer < ActiveModel::Serializer
  attributes :id, :wca_id, :name, :gender, :country_iso2, :delegate_status, :created_at, :updated_at
  attribute :dob, if: -> { is_current_resource_owner? && scope_exists?(:dob) }
  # Delegates's emails and regions are public information.
  attribute :email, if: -> { (is_current_resource_owner? && scope_exists?(:email)) || any_kind_of_delegate? }
  attribute :region, if: :any_kind_of_delegate?
  attribute :senior_delegate_id, if: :any_kind_of_delegate?

  attribute :avatar do
    {
      url: object.avatar.url,
      thumb_url: object.avatar.url(:thumb),
      is_default: !object.avatar?,
    }
  end

  has_many :teams

  link(:self) { api_v1_user_url object }

  # Helpers

  def is_current_resource_owner?
    object == resource_owner
  end

  def scope_exists?(scope)
    resource_owner&.doorkeeper_token&.scopes&.exists?(scope)
  end

  def any_kind_of_delegate?
    object.any_kind_of_delegate?
  end
end
