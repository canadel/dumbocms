desc "This task is called by cron"
task :cron => :environment do
  BulkImport.process!
  Account.sync!
end