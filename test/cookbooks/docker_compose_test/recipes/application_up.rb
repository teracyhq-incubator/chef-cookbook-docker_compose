#
# Cookbook Name:: docker_compose_test
# Recipe:: project_up
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

directory '/etc/docker-compose' do
  action :create
  owner 'root'
  group 'root'
  mode '0750'
end

cookbook_file '/etc/docker-compose/docker-compose_nginx.yml' do
  action :create
  source 'docker-compose_nginx.yml'
  owner 'root'
  group 'root'
  mode 0640
  notifies :up, 'docker_compose_application[nginx]', :delayed
end

docker_compose_application 'nginx' do
  action :up
  compose_files [ '/etc/docker-compose/docker-compose_nginx.yml' ]
end
