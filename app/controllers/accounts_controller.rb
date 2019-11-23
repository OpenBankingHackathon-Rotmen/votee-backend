class AccountsController < ApplicationController
	def index
		puts "YAHAN ACCOUNTS CONTROLLER #{params}"
		res = FetchBanksJob.new.perform(params[:id])

		puts res
	end
end