require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    context 'with valid credentials' do
      it 'returns success status' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(response).to have_http_status(:success)
      end
    end
  end


      it 'returns JWT token in header' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(response.headers['Authorization']).to be_present
      end


    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrong_password'
          }
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end





end