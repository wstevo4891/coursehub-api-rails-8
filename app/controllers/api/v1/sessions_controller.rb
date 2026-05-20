module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)

          render json: {
            token: token,
            exp: 24.hours.from_now.strftime("%m-%d-%Y %H:%M")
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
