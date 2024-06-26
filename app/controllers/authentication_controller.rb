class AuthenticationController < ApplicationController
  def signin
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json:  token , status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def signup
    @user = User.new(user_params)
    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: {message: "Account created successfully", token: token }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def reset_password
    @user = User.find_by(email: params[:email])

    if @user
      @user.password = params[:new_password]
      if @user.save
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def encode_token(payload)
    expire_hours = ENV['JWT_EXPIRE_HOURS'].to_i
    expire_time = expire_hours.hours.from_now.to_i
    exp_payload = { data: payload, exp: expire_time }

    encoded = JWT.encode exp_payload, ENV['SECRET_KEY_BASE']
    {token: encoded, exp: Time.at(expire_time)}
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
