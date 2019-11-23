class CallbackController < ApplicationController
	def index
		token = FetchTokenJob.new.perform(params[:code])

		redirect_to account_path(id: token)
	end
end
