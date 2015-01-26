require 'rails_helper'

def get_with_bearer(path, token, params={}, headers={})
  headers.merge!('authorization' => 'Bearer ' + token)
  get path, params, headers
end

def json
  JSON.parse(response.body)
end
