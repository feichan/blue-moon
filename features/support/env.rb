# encoding: UTF-8
require "digest/md5"
require "rack/test"
require 'rest_client'

require File.dirname(__FILE__) + "/../../app/lib/rimg"

#api.feature run the application
ENV["APP_ROOT"] = File.expand_path(File.dirname(__FILE__)) + "/../.."
ENV["RACK_ENV"] = "test" unless ENV["RACK_ENV"]

World(Rack::Test::Methods)
def app
  eval("Rack::Builder.new {( " + File.read(ENV["APP_ROOT"] + '/config.ru') + "\n )}")
end

