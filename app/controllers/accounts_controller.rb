class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])["accountNumber"]
		puts res
		redirect_to fetch_account_path(account_number: res, token: params[:token])
	end

	def fetch_account 
		puts params
	end
end