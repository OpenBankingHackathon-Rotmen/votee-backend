class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.perform(params[:id])

		puts res
	end
end