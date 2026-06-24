require 'open3'
require 'dotenv'
require_relative 'app/Webapp'
require_relative 'app/Desktop'

Dotenv.load('.env')

if ENV["LAUNCH_TYPE"] == "webonly"
  WebApp.run!
elsif ENV["LAUNCH_TYPE"] == "desktoponly"
  webapp_pid = fork do
    # This block runs in the child process
    WebApp.run!
  end

  # Launch Desktop in the main process
  desktop = Desktop.new
  desktop.run

  # Kill the child process (WebApp) when Desktop finishes
  Process.kill("TERM", webapp_pid) if Process.getpgid(webapp_pid)

  # Cleanup on exit
  at_exit do
    Process.kill("TERM", webapp_pid) if Process.getpgid(webapp_pid)
  rescue Errno::ESRCH
    # Process already terminated
  end
else
  raise "LAUNCH_TYPE not properly declared in .env file (needs to be 'webonly' or 'desktoponly')"
end