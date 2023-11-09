[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log

[program:rails]
command=/bin/bash -c "./scripts/start_rails.sh"
autostart=true
autorestart=true
user=appuser
stdout_logfile=/var/log/supervisor/rails_stdout.log
stderr_logfile=/var/log/supervisor/rails_stderr.log