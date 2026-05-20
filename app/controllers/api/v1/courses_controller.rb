module Api
  module V1
    class CoursesController < ApplicationController
      def publish
        @course = Course.find(params[:id])

        if @course.publish!
          render json: @course, status: :ok
        else
          render json: { errors: "Could not publish course" }, status: :unprocessable_content
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Course not found" }, status: :not_found
      end

      def drafts
        @draft_courses = Course.drafts

        render json: @draft_courses, status: :ok
      end
    end
  end
end
