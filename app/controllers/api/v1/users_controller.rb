module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      before_action :set_user, only: [ :show, :update, :destroy ]

      def index
        @users = policy_scope(User)
        render json: @users, status: :ok
      end

      def show
        authorize @user
        render json: @user, status: :ok
      end

      def create
        authorize User
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.to_hash }, status: :unprocessable_content
        end
      end

      def update
        authorize @user

        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: { errors: @user.errors.to_hash }, status: :unprocessable_content
        end
      end

      def destroy
        authorize @user
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end

      def user_params
        params.require(:user).permit(
          :name,
          :email,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
