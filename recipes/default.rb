#
# Cookbook Name:: tasktop-sync-studio
# Recipe:: default
#
# Copyright 2014, Lonnie VanZandt
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "rar" do
  action :upgrade
end
  
package "unrar" do
  action :upgrade
end

directory "#{node['tasktop-sync-studio']['zipDir']}" do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute "reassemble zip from rar fragments" do
  command "unrar x -y #{node['tasktop-sync-studio']['rarFile']} #{node['tasktop-sync-studio']['zipDir']}"
  creates #{node['tasktop-sync-studio']['zipFile']}
end

execute "unzip the installer" do
  command "cd #{node['tasktop-sync-studio']['zipDir']}; unzip #{node['tasktop-sync-studio']['zipFile']}"
  creates #{node['tasktop-sync-studio']['zipDir']}/mksclient.bin
end

directory "#{node['tasktop-sync-studio']['installDir']}" do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute "silently install the client" do
  command "./mksclient.bin -DinstallLocation=#{node['tasktop-sync-studio']['installDir']} -i silent"
  creates #{node['tasktop-sync-studio']['installDir']}/foo
end

directory "#{node['tasktop-sync-studio']['zipDir']}" do
  action :delete
end




    
