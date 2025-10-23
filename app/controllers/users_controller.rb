class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    render json: {
      id: current_user.id,
      email: current_user.email,
      name: current_user.name,
      created_at: current_user.created_at,
      jti: current_user.jti
    }, status: :ok
  end
end