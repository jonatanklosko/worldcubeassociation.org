class Api::V1::RegistrationsController < Api::V1::Base
  def index
    render json: accessible_registrations, include: params[:include]
  end

  def show
    registration = accessible_registrations.find_by(id: params[:id])
    ensure_found registration
    render json: registration, include: params[:include]
  end

  private
    def accessible_registrations
      competition = Competition.find_by(id: params[:competition_id])
      ensure_found competition
      registrations = competition.registrations.includes(:user, :events)
      resource_owner&.can_manage_competition?(competition) ? registrations : registrations.accepted
    end
end
