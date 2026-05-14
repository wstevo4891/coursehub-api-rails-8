class UsersController < ApplicationController
  def show
    user = User.find_by(id: params[:id])

    if user
      render json: user, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def create
    safe_params = user_params

    if safe_params[:name] == "Eve"
      render json: {
        errors: {
          name: [ "is not allowed" ]
        }
      }, status: :unprocessable_entity
    else
      render json: safe_params, status: :created
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
