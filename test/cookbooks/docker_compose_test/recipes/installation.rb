#
# Cookbook Name:: docker_compose_test
# Recipe:: installation
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

docker_installation 'default' do
 action :create
end

include_recipe 'docker_compose::installation'
