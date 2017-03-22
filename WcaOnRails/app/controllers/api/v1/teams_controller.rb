class Api::V1::TeamsController < Api::V1::Base
  def index
    render json: Team.includes(team_members: [:user]), include: params[:include]
  end

  def show
    team = Team.includes(team_members: [:user]).find_by((params[:id] =~ /^\d+$/ ? 'id' : 'friendly_id') => params[:id])
    ensure_found team
    render json: team, include: params[:include]
  end
end
