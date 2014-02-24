worker_processes 12

user "serveradmin", "serveradmin"
working_directory "/var/app/pn-tickets" # available in 0.94.0+
# listen "/var/app/tmp/sockets/unicorn.sock", :backlog => 64
listen 5000
timeout 180
pid "/var/app/tmp/pids/unicorn.pid"

stderr_path "/var/app/pn-tickets/log/unicorn.stderr.log"
stdout_path "/var/app/pn-tickets/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
