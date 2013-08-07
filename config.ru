require "bundler/setup"
require "sinatra"

run Sinatra::Application

#set environment status
ENV["RACK_ENV"] ||= "development"
# set root path
ENV["APP_ROOT"] = File.expand_path(File.dirname(__FILE__))

# require global variables
set :global_vars, YAML.load(ERB.new(File.read(ENV["APP_ROOT"] + '/config/global_vars.yml')).result)

# sinatra setting
set :root, ENV["APP_ROOT"]
set :environment, ENV["RACK_ENV"].to_sym
# disable rack json protect
set :protection, :except => [:json_csrf]

# require controller
Dir[ENV["APP_ROOT"] + "/app/controllers/*.rb"].each {|file| require file}
# require libs
require ENV["APP_ROOT"] + "/app/lib/rimg.rb"
# require models
require ENV["APP_ROOT"] + "/app/models/image.rb"

# run it!
run Sinatra::Application