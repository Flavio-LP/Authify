require 'swagger_helper'

RSpec.describe 'Sessions API', type: :request do
  path '/users/sign_in' do
    post 'Sign in' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: ['email', 'password']
          }
        }
      }

      response '200', 'user signed in' do
        let(:user) { create(:user) }
        let(:user) { { user: { email: user.email, password: 'password123' } } }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:user) { { user: { email: 'wrong@email.com', password: 'wrong' } } }
        run_test!
      end
    end
  end
end

