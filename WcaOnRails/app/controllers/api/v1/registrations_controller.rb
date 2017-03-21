class Api::V1::RegistrationsController < Api::V1::Base
  def index
    allow_including :competition, :user, :events
    competition = Competition.find_by(id: params[:competition_id])
    ensure_found competition
    render json: competition.registrations.includes(params[:include]), include: params[:include]
  end
end
