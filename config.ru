# This file is used by Rack-based servers to start the application.

run Myflix::Application
require ::File.expand_path('../config/environment',  __FILE__)
