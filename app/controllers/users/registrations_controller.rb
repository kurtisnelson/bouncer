class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  def create
    @user = User.new
    @user.email = user_params['email']
    @user.password = user_params['password']
    @user.password_confirmation = user_params['password_confirmation']

    if @user.save
      respond_with @user
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { respond_with @user }
      end
    end
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
