require 'sinatra'
require 'net/http'

configure do
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

get '/*' do
    @dn = request.host

    #request.body              # request body sent by the client (see below)
    #request.scheme            # "http"
    #request.script_name       # "/example"
    #request.path_info         # "/foo"
    #request.port              # 80
    #request.request_method    # "GET"
    #request.query_string      # ""
    #request.content_length    # length of request.body
    #request.media_type        # media type of request.body
    #request.host              # "example.com"
    #request.get?              # true (similar methods for other verbs)
    #request.form_data?        # false
    #request["SOME_HEADER"]    # value of SOME_HEADER header
    #request.referer           # the referer of the client or '/'
    #request.user_agent        # user agent (used by :agent condition)
    #request.cookies           # hash of browser cookies
    #request.xhr?              # is this an ajax request?
    #request.url               # "http://example.com/example/foo"
    #request.path              # "/example/foo"
    #request.ip                # client IP address
    #request.secure?           # false
    #request.env               # raw env hash handed in by Rack

    
    
    if request.cookies['cookie_auth'] == 'authentificate'
	uri = URI(request.url)
	req = Net::HTTP::Get.new(uri)
	
	req['User-Agent'] = request.user_agent
	req['Cookies']    = request.cookies
	req['Host']       = request.host
	
	puts req.to_hash
	
	res = Net::HTTP.start(uri.hostname, 80) {|http|
	    http.request(req)
	}
	
	if res.is_a?(Net::HTTPSuccess)
	    res.body
	else
	    'error occured'
	end
    else
	erb :index
    end
end

