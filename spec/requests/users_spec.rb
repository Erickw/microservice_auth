require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:user_email) { user.email }
  let(:user_password) { user.password }
  let(:headers) { valid_headers }

  describe 'GET /users/:id' do
    before { get "/users/#{user_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }
      let(:not_found_message) {{"error" => "User not found"}}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)).to eq(not_found_message)
      end
    end

    context 'when the token is invalid' do
      let(:signature_failed_message) {{"errors" => "Signature verification failed"}}

      before { get "/users/#{user_id}", headers: invalid_token }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a signature failed message' do
        expect(JSON.parse(response.body)).to eq(signature_failed_message)
      end
    end

    context 'when the token is expired' do
      let(:signature_expired_message) {{"errors" => "Signature has expired"}}

      before { get "/users/#{user_id}", headers: expired_token }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a signature expired message' do
        expect(JSON.parse(response.body)).to eq(signature_expired_message)
      end
    end
  end

  describe 'POST /reset_password' do
    let(:valid_attributes) { { email: user_email, password: user_password, new_password: 'newpassword' }.to_json }
    let(:invalid_attributes) { { email: user_email, password: user_email, new_password: '123321' }.to_json }
    let(:failure_message) { {"password"=>["is too short (minimum is 8 characters)"]} }

    context 'when request is valid' do
      before { post "/reset_password", params: valid_attributes, headers: headers }

      it 'updates the user password' do
        expect(response).to have_http_status(200)
        expect(json['message']).to match(/Password updated successfully/)
      end
    end

    context 'when request is invalid' do
      before { post "/reset_password", params: invalid_attributes, headers: headers }

      it 'returns a validation failure message' do
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to include(failure_message)
      end
    end
  end

  describe 'PATCH /users/:id' do
    let(:valid_attributes) { { name: 'Testonildo Neto' }.to_json }

    context 'when the record exists' do
      before { put "/users/#{user_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        user.reload
        expect(user.name).to eq('Testonildo Neto')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}", headers: headers }

    it 'return empty response' do
      expect(response.body).to be_empty
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
