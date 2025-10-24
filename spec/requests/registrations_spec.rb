require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST /users' do
    let(:valid_attributes) do
      {
        user: {
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: 'invalid',
          password: '123'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post user_registration_path, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'returns success status' do
        post user_registration_path, params: valid_attributes
        expect(response).to have_http_status(:success)
      end

      it 'returns JWT token in header' do
        post user_registration_path, params: valid_attributes
        expect(response.headers['Authorization']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          post user_registration_path, params: invalid_attributes
        }.not_to change(User, :count)
      end

      it 'returns unprocessable entity status' do
        post user_registration_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end