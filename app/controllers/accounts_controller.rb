class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])
		puts res

		redirect_to fetch_account_path(account_number: res, token: params[:token], code: params[:code])
	end

	def fetch_account 
		acc_number = params["account_number"][0]["accountNumber"]		
		auth = FetchExchangeTokenJob.new.perform(params["token"])
		puts auth

		a = FetchAccountInfoJob.new.perform(acc_number, auth)

		puts "YE WALI DELHO #{a}"
		puts "ACCOUNT: #{acc_number}\nTOKEN: #{auth}\n"
	end
end