web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
sidekiq: bundle exec sidekiq
##dev only
db: mongod --dbpath=.mongodb
redis: redis-server
