class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    @user = User.find_by(email: params[:email])
    @user.reset_password_token = SecureRandom.hex 12
    if @user.save
      Mailer.password_reset @user.id
      head :no_content
    else
      head :bad_request
    end
  end
end
