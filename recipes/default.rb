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

package "unzip" do
  action :upgrade
end

getHomeCmd = Mixlib::ShellOut.new("useradd -D|grep HOME|cut -d '=' -f 2")
getHomeCmd.run_command

homeDir = getHomeCmd.stdout.chomp

zipDir = node['tasktop-sync-studio']['zipDir'].sub( /~/, "#{homeDir}/" )

directory "#{zipDir}" do
  owner 'root'
  group 'root'
  mode '0644'
  recursive true
  action :create
end

rarFile = node['tasktop-sync-studio']['rarFile'].sub( /~/, "#{homeDir}/" )
zipFile = node['tasktop-sync-studio']['zipFile'].sub( /~/, "#{homeDir}/" )

execute "reassemble zip from rar fragments" do
  command "unrar x -y #{rarFile} #{zipDir}"
  creates "#{zipFile}"
end

execute "unzip the installer" do
  command "cd #{zipDir}; unzip #{zipFile}"
  creates "#{zipDir}/mksclient.bin"
end

installDir = node['tasktop-sync-studio']['installDir'].sub( /~/, "#{homeDir}/" )

directory "#{installDir}" do
  owner 'root'
  group 'root'
  mode '0644'
  recursive true
  action :create
end

execute "silently install the client" do
  command "./mksclient.bin -DinstallLocation=#{installDir} -i silent"
  creates "#{installDir}/foo"
end

directory "#{zipDir}" do
  action :delete
end




    
