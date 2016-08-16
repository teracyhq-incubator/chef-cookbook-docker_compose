#
# Cookbook Name:: docker_compose
# Resource:: application
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

property :project_name, String, name_property: true
property :compose_files, Array, required: true

default_action :up

def get_compose_params
  "-p #{project_name}" +
      ' -f ' + compose_files.join(' -f ')
end

action :up do
  execute "running docker-compose up for project #{project_name}" do
    command "docker-compose #{get_compose_params} up -d"
    user 'root'
    group 'root'
  end
end


action :down do
  execute "running docker-compose down for project #{project_name}" do
    command "docker-compose #{get_compose_params} down -d"
    user 'root'
    group 'root'
  end
end
