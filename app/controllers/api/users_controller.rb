module Api
  class UsersController < ApplicationController
    before_action :authenticate!

    def me
      render json: { user: { id: current_user.id, email: current_user.email } }, status: :ok
    end
  end
end
