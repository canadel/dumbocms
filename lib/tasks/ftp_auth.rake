namespace(:cms) do
  desc "This task is called by PureFTPd"
  task(:ftp_auth => :environment) { puts Account.ftp_auth }
end