class RegistrationSerializer < ActiveModel::Serializer
  attributes :id
  attribute :status do
    object.checked_status
  end

  has_one :user
  has_one :competition
  has_many :events

  link(:self) { api_v1_competition_registration_url object.competition, object }
  link(:user) { api_v1_user_url object.user }
  link(:competition) { api_v1_competition_url object.competition }
end
