#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "httpd" do
  action :install
end

#template "/var/www/html/index.html" do
#  source "index.html.erb"
#  mode   "0644"
#end


 file '/etc/chef/validation.pem' do
 	action :delete
end	

# disable the default virtual host
execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disabled" do
	only_if do
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart, "service[httpd]"
end

#iterate over the apache sites
node["apache"]["sites"].each do | site_name, site_data |
	# set the document root
	document_root = "/srv/apache/#{site_name}"

	template "/etc/httpd/conf.d/#{site_name}.conf" do
		source "custom.erb"
		mode "0644"
		variables(
				:document_root => document_root,
				:port => site_data["port"]
			)
		notifies :restart, "service[httpd]"
	end

	directory document_root do
		mode "0755"
		recursive true
	end

	template "#{document_root}/index.html" do
		source "index.html.erb"
		mode "0664"
		variables(:site_name => site_name, :port => site_data["port"])
 	end
end

service "httpd" do
  action [:start, :enable]
end
