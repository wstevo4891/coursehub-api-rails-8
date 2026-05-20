class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authorize_request

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  attr_reader :current_user

  def authorize_request
    token = header_from_request

    if token
      begin
        decoded = JsonWebToken.decode(token)

        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :unauthorized
      rescue JWT::ExpiredSignature, JWT::VerificationError => e
        render json: { error: e.message }, status: :unauthorized
      end
    else
      render json: { error: "Authorization header missing" }, status: :unauthorized
    end
  end

  def header_from_request
    auth_header = request.headers["Authorization"]

    return nil unless auth_header.present?

    auth_header.split(" ").last
  end

  def user_not_authorized
    render json: {
      error: "You are not authorized to perform this action."
    }, status: :forbidden
  end
end
