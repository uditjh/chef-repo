# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "mksadmin"
client_key               "#{current_dir}/mksadmin.pem"
validation_client_name   "wu-validator"
validation_key           "#{current_dir}/wu-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/wu"
cache_type               'BasicFile'
cache_options( :path => "C:/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
