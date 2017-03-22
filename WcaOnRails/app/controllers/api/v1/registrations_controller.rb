class Api::V1::RegistrationsController < Api::V1::Base
  def index
    competition = Competition.find_by(id: params[:competition_id])
    ensure_found competition
    render json: competition.registrations.includes(:user, :events), include: params[:include]
  end

  def show
    registration = Registration.includes(:user, :events).find_by(competition_id: params[:competition_id], id: params[:id])
    ensure_found registration
    render json: registration, include: params[:include]
  end
end
