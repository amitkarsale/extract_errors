#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
	db = URI.parse('mysql://root:root@localhost:3306')

	# 	ActiveRecord::Base.establish_connection(
	# 		:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
	# 		:host     => db.host,
	# 		:username => db.user,
	# 		:password => db.password,
	# 		:database => db.path[1..-1],
	# 		:encoding => 'utf8'
	# )
		
	ActiveRecord::Base.establish_connection(
			:adapter => 'mysql2',
			:host     => 'localhost',
			:username => 'root',
			:password => 'root',
			:database => 'error_reporting',
			:encoding => 'utf8'
	)
end