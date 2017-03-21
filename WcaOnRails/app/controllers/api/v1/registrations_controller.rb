class Api::V1::RegistrationsController < Api::V1::Base
  def index
    competition = Competition.find_by(id: params[:competition_id])
    ensure_found competition
    render json: competition.registrations.includes(:competition, :user, :events), include: [:competition, :user, :events]
  end
end
