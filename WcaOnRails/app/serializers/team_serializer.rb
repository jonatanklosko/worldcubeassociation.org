class TeamSerializer < ActiveModel::Serializer
  attributes :id, :friendly_id, :name, :description, :created_at

  has_many :team_members

  link(:self) { api_v1_team_url object }
end
