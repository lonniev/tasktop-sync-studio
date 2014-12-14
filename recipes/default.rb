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

chromeFile = Pathname.new( Chef::Config[:file_cache_path] ).join( "GoogleChromeStandaloneEnterprise.msi" )

remote_file chromeFile.to_s do
  source "https://dl-ssl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B806F36C0-CB54-4A84-A3F3-0CF8A86575E0%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dfalse/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"
  action :create_if_missing
end

#package chromeFile.to_s do
#  action :install
#end

dosPath = chromeFile.expand_path().to_s.gsub( '/', '\\' )

execute 'Install Chrome' do
  command "msiexec /qn /i #{dosPath}"
  action :run
end

package 'wget' do
  source 'http://sourceforge.net/projects/gnuwin32/files/wget/1.11.4-1/wget-1.11.4-1-setup.exe'
  action :install
end

# Using wget to download content protected by referer and cookies.
# 1. get base url and save its cookies in file
# 2. get protected content using stored cookies

repoSite = 'https://files.tasktop.com/public.php'
repoId = '7d481ea5e31a0a39b5d9eade8c90697e'
repoPass = 'foo'

filePath = '//Sodius-Engineering.license'
asLocalFile = 'Sodius-Engineering.license'

remote_file = "#{repoSite}?service=files&t=#{repoId}&download&path=#{filePath}"

execute 'authenticate at Tasktop and save session cookies' do
  command 'wget --post-data "password=#{repoPass}" --no-check-certificate --cookies=on --keep-session-cookies --save-cookies=#{cookieFile} "#{repoSite}?service=files&t=#{repoId}" -O #{junkFile}'
end

execute 'download remote file with session cookies' do
  command 'wget -O #{asLocalFile} --referer=#{repoSite} --cookies=on --load-cookies=#{cookieFile} --keep-session-cookies --save-cookies=#{cookieFile} #{remoteFile}'
end
