module ControllerMacros
  def login_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin)
    @admin.confirm!
    sign_in @admin
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
  end
end
