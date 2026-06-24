require 'open3'
require 'dotenv'
require_relative 'app/Webapp'
require_relative 'app/Desktop'


webapp_thread = Thread.new do
  WebApp.run!
end

desktop = Desktop.new
desktop.run

# When the main thread (desktop) is done, we stop webapp
webapp_thread.join
