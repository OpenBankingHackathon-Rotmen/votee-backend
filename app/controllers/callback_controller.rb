class CallbackController < ApplicationController
	def index
		token = FetchTokenJob.new.perform(params[:code])

		redirect_to accounts_path(token)
	end
end
