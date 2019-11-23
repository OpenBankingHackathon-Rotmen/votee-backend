class FetchUserController < ApplicationController
	def show
		respond_to do |format|  
		  format.json { render json: user, status: :ok}
		  format.html 
  	end    
	end

	def index
		url = AuthUserJob.new.perform

		redirect_to url
	end
private
	def user
		{
			firstName: "Marcello",
			lastName: "Bardus",
			accountNum: "123123123123123123"
		}
	end
end