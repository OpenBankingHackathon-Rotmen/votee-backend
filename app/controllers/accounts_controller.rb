class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])
		puts res

		redirect_to fetch_account_path(account_number: res, token: params[:token])
	end

	def fetch_account 
		acc_number = params["account_number"][0]["accountNumber"]
		auth = params["token"]
		a = FetchAccountInfoJob.new.perform(acc_number, auth)
		puts a
		
		puts "ACCOUNT: #{acc_number}\n TOKEN: #{auth}\n"
	end
end