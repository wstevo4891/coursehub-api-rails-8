module Api
  module V1
    class EnrollmentsController < ApplicationController
      before_action :set_course

      def index
        @enrollments = @course.enrollments
        render json: @enrollments, status: :ok
      end

      def create
        @enrollment = @course.enrollments.new(enrollment_params)

        @enrollment.user = User.find_by(id: enrollment_params[:user_id])

        if @enrollment.save
          render json: @enrollment, status: :created
        else
          render json: { errors: @enrollment.errors.to_hash }, status: :unprocessable_content
        end
      end

      private

      def set_course
        @course = Course.find(params[:course_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Course not found" }, status: :not_found
      end

      def enrollment_params
        params.require(:enrollment).permit(:user_id)
      end
    end
  end
end
