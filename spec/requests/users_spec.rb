require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /profile' do
    context 'when authenticated' do
      before { sign_in user }

      it 'returns success status' do
        get profile_path
        expect(response).to have_http_status(:success)
      end

      it 'returns user data' do
        get profile_path
        json = JSON.parse(response.body)
        expect(json['email']).to eq(user.email)
      end
    end

    context 'when not authenticated' do
      it 'returns unauthorized status' do
        get profile_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end