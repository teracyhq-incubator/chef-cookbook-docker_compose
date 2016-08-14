#
# Cookbook Name:: docker_compose
# Recipe:: installation
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

def get_install_url
  release = node['docker_compose']['release']
  kernel_name = get_command_stdout 'uname -s'
  machine_hw_name = get_command_stdout 'uname -m'
  "https://github.com/docker/compose/releases/download/#{release}/docker-compose-#{kernel_name}-#{machine_hw_name}"
end


def get_command_stdout(command)
  cmd = Mixlib::ShellOut.new(command)
  cmd.valid_exit_codes = [ 0 ]
  cmd.run_command
  cmd.error!
  cmd.stdout.strip
end

command_path = node['docker_compose']['command_path']
install_url = get_install_url

package 'curl' do
  action :install
end

execute 'install docker-compose' do
  command "curl -sSL #{install_url} > #{command_path} && chmod +x #{command_path}"
  creates '/usr/local/bin/docker-compose'
  user 'root'
  group 'root'
  umask '0027'
end
