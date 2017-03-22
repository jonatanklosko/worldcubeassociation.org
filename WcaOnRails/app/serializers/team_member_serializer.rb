class TeamMemberSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :team_leader

  has_one :team
  has_one :user

  link(:user) { api_v1_user_url object.user }
  link(:team) { api_v1_team_url object.team }
end
