class StacksController < ApplicationController

	def get_stacks
		if $redis.get(params[:url]).nil?
			if !params[:url].nil?
				AnalysisWorker.perform_async(params[:url])
				render json: {status: "processing"}
			else
				render json: {status: "false"}
			end
		else
			if params[:refresh] == "true"
				AnalysisWorker.perform_async(params[:url])
				render json: {status: "processing"}
			else
				render json: $redis.get(params[:url])
			end
		end
	end

end
