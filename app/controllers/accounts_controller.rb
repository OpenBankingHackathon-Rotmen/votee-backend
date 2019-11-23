class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])
		puts res

		redirect_to fetch_account_path(account_number: res, token: params[:token])
	end

	def fetch_account 
		puts "THIS WHAT FETCH GOT #{params["account_number"]["account_number"]}"
	end
end