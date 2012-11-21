def server
  Testrail.config.server + Testrail.config.api_path
end

def command
  'a_command'
end

def url_prefix(command = 'a_command')
  server + command
end

def key
  '&key=' + String(Testrail.config.api_key)
end

def headers
  Testrail.config.headers
end

def body
  {
    an_object: {
      param1: 'a value',
      param2: 'another value',
      param3: '42'
    }
  }
end

def post_options
  { 
    headers: headers.merge({"Content-Type" => "application/x-www-form-urlencoded"}), 
    body: body
  }
end

def get_options
  { headers: headers }
end
