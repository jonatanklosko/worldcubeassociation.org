class RegistrationSerializer < ActiveModel::Serializer
  attributes :id, :accepted_at, :deleted_at

  has_one :user
  has_one :competition
  has_many :events

  link(:self) { api_v1_competition_registrations_url object.competition }
end
