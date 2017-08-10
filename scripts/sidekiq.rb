#worker: bundle exec sidekiq -c 1 -v


run_sidekiq_command = "bundle exec sidekiq -c 2 -v"

command = "#{run_sidekiq_command}"

exec command
