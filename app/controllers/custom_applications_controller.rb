class CustomApplicationsController < Doorkeeper::ApplicationsController
  before_action do
    authenticate_user!
    head :forbidden unless current_user.super_admin?
  end
end
