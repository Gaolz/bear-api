class ApplicationController < ActionController::API
  def authenticate!
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded = JwtService.decode(token) if token

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
