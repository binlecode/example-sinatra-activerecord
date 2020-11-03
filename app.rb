require 'sinatra'
require "sinatra/reloader" if development?
require 'sinatra/activerecord'
require 'json'

require './models'

# The `set` method takes a setting name and value and creates an attribute
# on the application.
# Settings can be accessed within requests via the `settings` object.

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}
# or set :database_file, "path/to/database.yml"
# if config/database.yml, it will automatically be loaded, no need to specify it

# Sinatra sets up logging with Rack::Logger in its default middleware,
# which can be initialized with a log level instead of just `true`
# (see http://rack.rubyforge.org/doc/Rack/Logger.html)
set :logging, Logger::DEBUG
# setup logger to write to stdout, which is the default setting
# set :logger, Logger.new(STDOUT)

# enable :sessions

# before filter to set content type to json
before do
  content_type :json
end

get '/users' do
  # content_type :json
  User.all.to_json
end

get '/users/:id' do
  # User.find(id) will raise exception if not found
  @user = User.find_by_id(params[:id])
  return @user.to_json if @user

  status 404
end

# create
post '/users' do
  # for request with Content-Type: application/x-www-form-urlencoded
  # logger.info("received request form: #{params}")
  # @user = User.create(params)

  # for request with json body
  jsn = JSON.parse(request.body.read)
  logger.info("received request json: #{jsn.inspect}")

  # create method instantiates and saves the new instance to the database
  @user = User.create(jsn)
  if @user.valid?
    status 201 # created
    return @user.to_json
  else
    status 422 # unprocessable entity
    return @user.errors.to_json
  end
end

# update
put '/users/:id' do
  @user = User.find_by_id(params[:id])
  return status 404 unless @user

  jsn = JSON.parse(request.body.read)
  logger.debug(">> json body: #{jsn}")
  # remove possible id field from json body
  # this is to prevent change on object id
  jsn.delete('id')
  logger.debug(">> json without id: #{jsn}")
  @user.update(jsn)
  if @user.valid?
    status 201 # created
    return @user.to_json
  else
    status 422 # unprocessable entity
    return @user.errors.to_json
  end
end

# DELETE
#
# DELETE response SHOULD have status code:
# 200 (OK) if the response includes an entity describing the status,
# 202 (Accepted) if the action has been queued
# 204 (No Content) if the action has been performed but the response does not include an entity
# DELETE operations should be idempotent.
#
delete '/users/:id' do
  @user = User.find_by_id(params[:id])
  logger.debug(">> deleting user: #{@user}")
  @user&.destroy # delete if exists
  status 204
end
