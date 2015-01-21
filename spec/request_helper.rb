require 'rails_helper'

def get_as_parse(path, params={}, headers={})
  headers.merge!('Token' => ENV['PARSE_TOKEN'])
  get path, params, headers
end
def post_as_parse(path, params={}, headers={})
  headers.merge!('Token' => ENV['PARSE_TOKEN'])
  post path, params, headers
end

def put_as_machine(path, params={}, headers={})
  headers.merge!('Token' => ENV['MACHINE_TOKEN'])
  put path, params, headers
end
def post_as_machine(path, params={}, headers={})
  headers.merge!('Token' => ENV['MACHINE_TOKEN'])
  post path, params, headers
end
def get_as_machine(path, params={}, headers={})
  headers.merge!('Token' => ENV['MACHINE_TOKEN'])
  get path, params, headers
end

def get_with_bearer(path, token, params={}, headers={})
  headers.merge!('authorization' => 'Bearer ' + token)
  get path, params, headers
end

def current_machine_guid
  "t2Pbf1ZciT"
end

def json
  JSON.parse(response.body)
end
