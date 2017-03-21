class Api::V1::RegistrationsController < Api::V1::Base
  def index
    allow_including :competition, :user, :events
    competition = Competition.find_by(id: params[:competition_id])
    ensure_found competition
    render json: competition.registrations.includes(params[:include]), include: params[:include]
  end

  def show
    allow_including :competition, :user, :events
    registration = Registration.includes(params[:include]).find_by(competition_id: params[:competition_id], id: params[:id])
    ensure_found registration
    render json: registration, include: params[:include]
  end
end
