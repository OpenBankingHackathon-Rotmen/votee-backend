class AccountsController < ApplicationController
	def index
		res = FetchBanksJob.new.perform(params[:id])

		puts res
	end
end