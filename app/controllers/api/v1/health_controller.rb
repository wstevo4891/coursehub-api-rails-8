module Api
  module V1
    class HealthController < ApplicationController
      skip_before_action :authorize_request

      def index
        render json: { status: "ok" }
      end
    end
  end
end
