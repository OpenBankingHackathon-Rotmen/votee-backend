class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])
		puts res

		redirect_to fetch_account_path(account_number: res, token: params[:token], code: params[:code])
	end

	def fetch_account 
		# acc_number = params["account_number"][0]["accountNumber"]		
		acc_number = "35551905220000000000019315"
		# auth = FetchExchangeTokenJob.new.perform(params["code"])
		# puts auth

		a = FetchAccountInfoJob.new.perform(acc_number, params[:token])

		puts "YE WALI DELHO #{a}"
		# puts "ACCOUNT: #{acc_number}\nTOKEN_NEW: #{auth}\n"
		# puts "TOKEN_OLD: #{params["token"]}\n"

		redirect_to "https://votee.now.sh/redirect/?accountNumber=#{a["account"]["accountNumber"]}&accountType=#{a["account"]["accountHolderType"]}"
	end
end
