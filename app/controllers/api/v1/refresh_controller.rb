module Api
  module V1
    class RefreshController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        token_param = params.require(:refresh_token)

        @refresh_token = RefreshToken.find_by(token: token_param)

        if !@refresh_token || @refresh_token.expires_at < Time.now
          render json: {
            error: "Invalid or expired refresh token"
          }, status: :unauthorized
        else
          @user = @refresh_token.user

          access_token_exp = 15.minutes.from_now
          access_token = JsonWebToken.encode({ user_id: @user.id }, access_token_exp)

          render json: {
            access_token: access_token,
            exp: access_token_exp.to_i
          }, status: :ok
        end
      end
    end
  end
end
