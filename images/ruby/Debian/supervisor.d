[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid
user=root

[program:rails]
command=/bin/bash -c "./scripts/start_rails.sh"
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/rails_stdout.log
stderr_logfile=/var/log/supervisor/rails_stderr.log
