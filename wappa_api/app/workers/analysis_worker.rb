class AnalysisWorker
  include Sidekiq::Worker
  def perform(url)
  	begin
			puts url

			output = `#{ENV["phantomjs_path"]} #{url}`
	  	stacks = JSON.parse(output)["applications"]
	  	puts stacks
	  	puts stacks.size
	  	stacks.each do |item|
	  		puts item["name"]
	  	end
	  	$redis.set(url, stacks.to_json)
	  rescue
	  	$redis.set(url, [].to_json)
	  end
  end
end