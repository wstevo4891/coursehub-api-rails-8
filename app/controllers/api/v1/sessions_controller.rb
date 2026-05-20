module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])
          @user.refresh_tokens.destroy_all

          refresh_token = @user.refresh_tokens.create!

          access_token_exp = 15.minutes.from_now
          access_token = JsonWebToken.encode({ user_id: @user.id }, access_token_exp)

          render json: {
            access_token: access_token,
            exp: access_token_exp.to_i,
            refresh_token: refresh_token.token
          }, status: :ok
        else
          render json: {
            error: "Invalid email or password"
          }, status: :unauthorized
        end
      end
    end
  end
end
