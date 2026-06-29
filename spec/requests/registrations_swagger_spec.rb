require 'swagger_helper'

RSpec.describe 'Registrations API', type: :request do
  path '/users' do
    post 'Cadastro de usuário' do
      tags 'Registration'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string, example: 'João Silva' },
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: %w[name email password password_confirmation]
          }
        }
      }

      response '201', 'usuário criado com sucesso' do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string }
                   }
                 }
               }
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               }
        run_test!
      end
    end
  end
end
