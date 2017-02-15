#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
	db = URI.parse('mysql://root:root@localhost:3306')

	ActiveRecord::Base.establish_connection(
			:adapter => 'mysql2',
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => 'kcsdw_2',
			:encoding => 'utf8'
	)
end