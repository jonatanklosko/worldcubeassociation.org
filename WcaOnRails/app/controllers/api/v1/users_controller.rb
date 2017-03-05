class Api::V1::UsersController < Api::V1::Base
  def index
    parameter 'page.number', default: 1
    parameter 'page.size', default: PAGINATION_PAGE_SIZE
    render json: User.page(params[:page][:number]).per(params[:page][:size])
  end

  def show
    user = User.find_by((params[:id] =~ User::WCA_ID_RE ? 'wca_id' : 'id') => params[:id])
    ensure_found user
    render json: user
  end
end
