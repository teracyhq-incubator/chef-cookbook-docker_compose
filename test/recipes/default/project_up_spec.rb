# # encoding: utf-8

# Inspec test for recipe docker_compose::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

# Ensure the correct image was pulled
describe command('docker ps -f name=nginx_web_server | awk \'BEGIN{FS="  +"} NR > 1 { print $2 }\'') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "nginx\n" }
end

# Ensure the nginx container is up
describe command('docker ps -f name=nginx_web_server | awk \'BEGIN{FS="  +"} NR > 1 { print $5 }\'') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /^Up / }
end

# Ensure nginx is listening on port 8888
describe port(8888) do
  it { should be_listening }
end
