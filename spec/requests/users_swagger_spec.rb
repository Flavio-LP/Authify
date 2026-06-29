require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/profile' do
    get 'Perfil do usuário autenticado' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'perfil retornado com sucesso' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 email: { type: :string },
                 name: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 jti: { type: :string }
               }
        run_test!
      end

      response '401', 'não autenticado' do
        run_test!
      end
    end
  end
end
