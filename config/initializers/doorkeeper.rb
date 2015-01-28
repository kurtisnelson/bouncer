Doorkeeper.configure do
  use_refresh_token
  # Change the ORM that doorkeeper will use.
  # Currently supported options are :active_record, :mongoid2, :mongoid3,
  # :mongoid4, :mongo_mapper
  orm :mongo_mapper

  resource_owner_authenticator do
    current_user || redirect_to(new_user_session_url)
  end

  resource_owner_from_credentials do |routes|
    u = User.find_for_database_authentication(:email => params[:username])
    u if u && u.valid_password?(params[:password])
  end

  resource_owner_from_assertion do
    token = params[:assertion]
    return if token.blank?
    facebook = URI.parse('https://graph.facebook.com/me?access_token=' + token)
    response = Net::HTTP.get_response(facebook)
    if response.code == "200"
      user_data = JSON.parse(response.body)
      User.from_facebook(user_data, token)
    end
  end

  grant_flows %w(assertion authorization_code client_credentials password)

  default_scopes :user
  optional_scopes :device

  access_token_expires_in 2.hours

  # skip_authorization do |resource_owner, client|
  #   client.superapp? or resource_owner.admin?
  # end
end
