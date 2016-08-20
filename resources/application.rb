#
# Cookbook Name:: docker_compose
# Resource:: application
#
# Copyright (c) 2016 Sebastian Boschert, All Rights Reserved.

property :project_name, kind_of: String, name_property: true
property :compose_files, kind_of: Array, required: true
property :remove_orphans, kind_of: [TrueClass, FalseClass], default: false
property :services, kind_of: Array, default: []
property :tls, kind_of: [TrueClass, FalseClass], default: false
property :tls_verify, kind_of: [TrueClass, FalseClass], default: false
property :tls_ca_cert, kind_of: String, default: nil
property :tls_cert, kind_of: String, default: nil
property :tls_key, kind_of: String, default: nil
property :skip_hostname_check, kind_of: [TrueClass, FalseClass], default: false

default_action :up

def not_empty?(str)
  str && str.is_a?(String) && !str.empty?
end

def get_compose_params
  params = "-p #{project_name}"
  params << ' -f ' << compose_files.join(' -f ')

  # TLS parameters
  if tls || tls_verify
    if tls
      params << ' --tls'
    end
    if tls_verify
      params << ' --tlsverify'
    end
    if not_empty?(tls_ca_cert)
      params << " --tlscacert #{tls_ca_cert}"
    end
    if not_empty?(tls_cert)
      params << " --tlscert #{tls_cert}"
    end
    if not_empty?(tls_key)
      params << " --tlskey #{tls_key}"
    end
    if skip_hostname_check
      params << ' --skip-hostname-check'
    end
  end

  params
end

def get_common_up_down_params
  params = ''

  if remove_orphans
    params << ' --remove-orphans'
  end
  if !services.nil?
    params << ' ' << services.join(' ')
  end

  params
end

def get_up_params
  '-d' << get_common_up_down_params
end

def get_down_params
  get_common_up_down_params
end

action :up do
  execute "running docker-compose up for project #{project_name}" do
    command "docker-compose #{get_compose_params} up #{get_up_params}"
    user 'root'
    group 'root'
  end
end


action :down do
  execute "running docker-compose down for project #{project_name}" do
    command "docker-compose #{get_compose_params} down  #{get_down_params}"
    user 'root'
    group 'root'
  end
end
