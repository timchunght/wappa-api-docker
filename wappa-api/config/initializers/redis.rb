$redis = if redis_url = ENV["REDISCLOUD_URL"]
  uri = URI.parse(redis_url)
  Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Redis.new
end

#$redis = Redis.new(host: ENV['REDIS_1_PORT_6379_TCP_ADDR'], port: 6379)