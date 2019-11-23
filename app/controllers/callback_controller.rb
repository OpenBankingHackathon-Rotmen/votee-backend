class CallbackController < ApplicationController
	def index
		token = FetchTokenJob.new.perform(params[:code])

		redirect_to accounts_path(token: token, code: params[:code])
	end
end
