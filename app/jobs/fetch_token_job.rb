require 'openssl'
require "base64"
require 'simple_uuid'
require 'net/http'
require 'open3'

class FetchTokenJob < ApplicationJob
  queue_as :default

  def perform(code)
  	path = "/home/user16adm/Desktop"
    raw = File.read "#{path}/pwtkey.pem" 
		rsa_private = OpenSSL::PKey::RSA.new raw

		rsa_public = rsa_private.public_key
		key_id = "9badbf4941f6223c039d5bc247919b1ba911eb65"
		qseal_URL = "https://gist.githubusercontent.com/archetype2142/610a37d823a268c9c24f4e780db77220/raw/609425285b001643de47bb4131b9dba0a770f9b8/qseal.pem"
		qseal_fingerprint_url = "5ef8081658f5fc72c7268938047646cf39536ee35c14ec6b4c3005c72c940fed"
		uuid = SimpleUUID::UUID.new.to_guid
		new_payload = request(code, uuid)

		header_fields = {
			alg: "RS256",
			typ: "JWT",
			kid: key_id,
			x5u: qseal_URL,
			"x5t#S256": qseal_fingerprint_url
		}

		token = JWT.encode new_payload, rsa_private, 'RS256', header_fields
		json = Base64.decode64(token.split('.')[1])
		token = token.gsub(token.split('.')[1], "")


	req = "curl --request POST \\
	  --url https://api-obh.kir.pl/v2_1_1.1/auth/v2_1_1.1/token \\
	  --header 'Accept: application/json' \\
	  --header 'Accept-Charset: utf-8' \\
	  --header 'Content-Type: application/json' \\
	  --header 'X-JWS-SIGNATURE: #{token}' \\
	  --header 'cache-control: no-cache' \\
	  --header 'X-REQUEST-ID: #{uuid}' \\
	  --data '#{json}' \\
	  --cert '#{path}/qwac.pem' \\
	  --key '#{path}/pwtkey.pem' \\
	  --insecure
	"
		
		stdout, stderr, status = Open3.capture3(req)
		JSON.parse(stdout)["access_token"]
  end

  def request code, uid
		{
		  "requestHeader": {
		    "requestId": "#{uid}",
		    "userAgent": "string",
		    "ipAddress": "string",
		    "sendDate": "2019-11-23T16:18:07.201Z",
		    "tppId": "string",
		    "isCompanyContext": true,
		    "psuIdentifierType": "string",
		    "psuIdentifierValue": "string",
		    "psuContextIdentifierType": "string",
		    "psuContextIdentifierValue": "string"
		  },
		  "grant_type": "authorization_code",
		  "Code": "#{code}",
		  "redirect_uri": "string",
		  "client_id": "string",
		  "refresh_token": "string",
		  "exchange_token": "string",
		  "scope": "string",
		  "scope_details": {
		    "privilegeList": [
		      {
		        "ais-accounts:getAccounts": {
		          "scopeUsageLimit": "single"
		        }
		      }
		    ],
		    "scopeGroupType": "ais-accounts",
		    "consentId": "#{uid}",
		    "scopeTimeLimit": "2020-11-23T16:18:07.202Z",
		    "throttlingPolicy": "psd2Regulatory"
		  },
		  "is_user_session": true,
		  "user_ip": "string",
		  "user_agent": "string"
		}
	end
end
