class Api::V1::TeamsController < Api::V1::Base
  def index
    render json: Team.all
  end

  def show
    team = Team.find_by((params[:id] =~ /^\d+$/ ? 'id' : 'friendly_id') => params[:id])
    ensure_found team
    render json: team
  end
end
