class ApplicationController < ActionController::API
  before_action :authorize_request, except: [:signup, :signin]

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = JWT.decode(header, ENV['SECRET_KEY_BASE'])[0]
      @current_user = User.find(decoded.dig("data", "user_id"))
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::ExpiredSignature => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
