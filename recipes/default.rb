#
# Cookbook:: nodejs_nginx
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update 'update_sources' do
  action :update
end

package 'nginx'
package 'nodejs'
package 'npm'


service 'nginx' do
  action [:enable, :start]
end

# Creating template in machine
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  notifies :restart, 'service[nginx]'
end

# Making symbolic link to above template
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

#
link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end

include_recipe 'nodejs'
# does not install npm by default


nodejs_npm 'pm2'
nodejs_npm 'react'
