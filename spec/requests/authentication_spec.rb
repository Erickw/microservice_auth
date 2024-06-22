require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) { create(:user) }
  let(:user_email) { user.email }
  let(:user_password) { user.password }

  describe 'POST /signup' do
    let(:valid_attributes) do
      { user: { name: 'Jubileia', email: 'test@mail.com', password: 'password123', password_confirmation: 'password123' } }
    end

    context 'when the request is valid' do
      before { post '/signup', params: valid_attributes }
      it 'creates a user' do
        expect(json['token']).not_to be_nil
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:failure_message) do
        {"password"=>["can't be blank"],
         "email"=>["is invalid", "can't be blank"]}
      end
      let(:invalid_attributes) do
        { user: { name: 'Jubileia' } }
      end

      before { post '/signup', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do

        expect(JSON.parse(response.body)).to include(failure_message)
      end
    end
  end

  describe 'POST /signin' do
    let(:valid_credentials) { { email: user_email, password: user_password } }
    let(:invalid_credentials) { { email: 'wrong@example.com', password: 'wrongpassword' } }

    context 'when the request is valid' do
      before { post '/signin', params: valid_credentials }

      it 'returns an authentication token' do
        expect(json['token']).not_to be_nil
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/signin', params: invalid_credentials }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Invalid email or password/)
      end
    end
  end

  describe 'POST /reset_password' do
    let(:headers) { valid_headers }
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
end
