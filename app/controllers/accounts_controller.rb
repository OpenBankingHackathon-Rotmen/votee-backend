class AccountsController < ApplicationController
	def create
		FetchBanksJob.perform(params[:token])
	end
end