class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])["accountNumber"]

		redirect_to account_path(id: res, token: params[:token])
	end

	def show 
		puts params
	end
end