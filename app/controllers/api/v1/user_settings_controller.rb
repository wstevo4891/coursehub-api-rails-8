module Api
  module V1
    class UserSettingsController < ApplicationController
      before_action :set_user

      def show
        @settings = @user.user_setting

        if @settings
          render json: @settings, status: :ok
        else
          render json: { error: "Settings not found for this user" }, status: :not_found
        end
      end

      def update
        @settings = UserSetting.find_or_initialize_by(user_id: @user.id)

        if @settings.update(user_settings_params)
          render json: @settings, status: :ok
        else
          render json: { errors: @settings.errors.to_hash }, status: :unprocessable_content
        end
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end

      def user_settings_params
        params.require(:settings).permit(
          :theme,
          :language,
          notifications: {}
        )
      end
    end
  end
end
