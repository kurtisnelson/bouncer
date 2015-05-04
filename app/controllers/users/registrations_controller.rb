class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    @user = User.new
    @user.email = user_params['email']
    @user.phone = user_params['phone']
    @user.password = user_params['password']
    @user.password_confirmation = user_params['password_confirmation']

    @user.save
    render_json_api @user
  end

  private

  def user_params
    if !params['users'].blank?
      return params['users']
    else
      raise BadRequestError
    end
  end
end
