class CallbackController < ApplicationController
	def index
		token = FetchTokenJob.new.perform(params[:code])

		puts "YAHAN CALLBACK CONTROLLER #{token}"
		redirect_to accounts_path(token: token)
	end
end
