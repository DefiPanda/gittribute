require "base64"

module ApplicationHelper
	def getParsedJSON(url, https)
	  uri = URI.parse(url)
	  http = Net::HTTP.new(uri.host, uri.port)
	  request = Net::HTTP::Get.new(uri.request_uri)
	  request.initialize_http_header({"Accept-Charset" => "utf-8"})
	  if https == 0
	    response = http.request(request)
	  else
	    response = Net::HTTP.start(uri.host, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
	        http.get uri.request_uri, 'User-Agent' => 'MyLib v1.2'
	      end
	    end
	  result = JSON.parse(response.body)
	end

	def verifiedRequest?(needle, stack)
	  if stack.include? needle
	  	true
      else
	    false
	  end
    end

    def getVerified(url, username, repo)
    	encoded_text = getParsedJSON("https://api.github.com/repos/#{username}/#{repo}/contents/README.md", 1)["content"]
        if encoded_text.nil? == false
          decoded_text = Base64.decode64(encoded_text)
          return verifiedRequest?(url, decoded_text)
        else
          false
        end
    end

    def getRepoInfo(username, repo)
        returned_json = getParsedJSON("https://api.github.com/repos/#{username}/#{repo}", 1)
        repo_id = returned_json["id"]
        repo_description = returned_json["description"]
        [repo_id, repo_description]
    end
end
