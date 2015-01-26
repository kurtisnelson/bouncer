class CustomApplicationsController < Doorkeeper::ApplicationsController
  before_filter :authenticate_admin!
end
