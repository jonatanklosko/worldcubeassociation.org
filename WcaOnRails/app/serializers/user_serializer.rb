class UserSerializer < ActiveModel::Serializer
  attributes :id, :wca_id, :gender, :country_iso2, :delegate_status, :created_at, :updated_at

  attribute :avatar do
    {
      url: object.avatar.url,
      thumb_url: object.avatar.url(:thumb),
      is_default: !object.avatar?,
    }
  end

  attribute :teams do
    object.current_team_members.includes(:team).map do |team_member|
      {
        friendly_id: team_member.team.friendly_id,
        leader: team_member.team_leader?,
      }
    end
  end

  link(:self) { users_url object }
end
