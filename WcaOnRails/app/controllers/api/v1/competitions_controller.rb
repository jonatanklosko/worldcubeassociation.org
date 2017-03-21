class Api::V1::CompetitionsController < Api::V1::Base
  def index
    parameter 'page.number', default: 1
    parameter 'page.size', default: PAGINATION_PAGE_SIZE
    render json: Competition.visible.page(params[:page][:number]).per(params[:page][:size])
  end

  def show
    allow_including :delegates, :organizers
    competition = Competition.visible.includes(params[:include]).find_by(id: params[:id])
    ensure_found competition
    render json: competition, include: params[:include]
  end
end
