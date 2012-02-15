#!/bin/sh

# Old code:
#/opt/ruby-ree-1.8.7-2011.03/bin/rake -f /home/dumbocms/dumbocms/Rakefile cms:ftp_auth --silent -- RAILS_ENV=production

# Current production code from Maciej
cd /home/dumbocms/production/current
su dumbocms -c "RAILS_ENV=production bundle exec rake cms:ftp_auth"
