require 'bundler/setup'
require 'open3'
require 'dotenv'

Dotenv.load('.env')
# valeurs par défaut pour les binaires packagés (.exe / .AppImage) lancés sans .env
ENV["DB_PATH"] ||= "database.csv"
ENV["LAUNCH_TYPE"] ||= Gem.win_platform? ? "webonly" : "desktoponly"
ENV["WEBAPP_IP"] ||= "127.0.0.1"
ENV["WEBAPP_PORT"] ||= "4567"

require_relative 'app/Webapp'

# OCRAN exécute ce script au build pour détecter les dépendances : on s'arrête avant de lancer le serveur
exit if defined?(Ocran)

if ENV["LAUNCH_TYPE"] == "webonly"
  WebApp.run!
elsif ENV["LAUNCH_TYPE"] == "desktoponly"
  # chargé ici seulement : GTK/WebKit n'existent pas sous Windows
  require_relative 'app/Desktop'

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