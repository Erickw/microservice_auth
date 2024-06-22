require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /signup' do
    let(:valid_attributes) do
      { user: { name: 'Jubileia', email: 'jubileiaf@mail.com', password: 'password123', password_confirmation: 'password123' } }
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
        {"password"=>["can't be blank", "is too short (minimum is 8 characters)"],
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
    let!(:user) { create(:user) }
    let(:valid_credentials) { { email: user.email, password: user.password } }
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
end
