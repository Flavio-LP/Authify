class Sessions::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = request.env['warden-jwt_auth.token']
    
    render json: {
      message: 'Login realizado com sucesso',
      token: token,
      user: {
        id: resource.id,
        email: resource.email,
        name: resource.name
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Logout realizado com sucesso' }, status: :ok
    else
      render json: { message: 'Não foi possível fazer logout' }, status: :unauthorized
    end
  end
end