class AccountsController < ApplicationController
	def create
		res = FetchBanksJob.perform(params[:token])

		puts res
	end
end