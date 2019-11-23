class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:token])

		redirect_to account_path(id: res["accountNumber"], token: params[:token])
	end

	def show 
		puts params
	end
end