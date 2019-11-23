class AccountsController < ApplicationController
	def show
		res = FetchBanksJob.perform(params[:id])

		puts res
	end
end