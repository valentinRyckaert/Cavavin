require 'open3'

# Run the first script in a separate process
pid1 = spawn("bundle exec ruby app/Webapp.rb -o 0.0.0.0 -p 4567")

# Run the second script in a separate process
pid2 = spawn("bundle exec ruby app/Desktop.rb")

# Wait for the second script to finish
Process.wait(pid2)

# Terminate the first script if the second script finishes first
Process.kill("TERM", pid1) if Process.getpgid(pid1)
