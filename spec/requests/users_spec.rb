require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
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
