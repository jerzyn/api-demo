set :user, "support@3scale.net"
server "ec2-54-242-30-126.compute-1.amazonaws.com", :app, :web, :db, :primary => true
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/amazon_aws.pem"] 