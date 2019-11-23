class AccountsController < ApplicationController
	def index
		puts "YAHAN ACCOUNTS CONTROLLER #{params}"
		res = FetchBanksJob.new.perform(params[:token])

		puts res
	end
end