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

windows_package 'Chrome' do
  source "https://dl-ssl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B806F36C0-CB54-4A84-A3F3-0CF8A86575E0%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dfalse/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"
  action :install
end

# Using wget to download content protected by referer and cookies.
# 1. get base url and save its cookies in file
# 2. get protected content using stored cookies

repoSite = node['tasktop-sync-studio']['loginUrl']
repoId = node['tasktop-sync-studio']['username']
repoPass = node['tasktop-sync-studio']['password']

remoteFile = node['tasktop-sync-studio']['source']

localFile = node['tasktop-sync-studio']['destination']

junkFile = "wget_junk"  
cookieFile = node['tasktop-sync-studio']['cookieFile'] || "cookies.txt"

wget = '"c:\Program Files\GnuWin32\bin\wget.exe"'

Dir.mktmpdir { |tdir|
  
  execute "authenticate at #{repoSite} and save session cookies" do
    cwd tdir
    command %Q(#{wget} --post-data "password=#{repoPass}" --no-check-certificate --cookies=on --keep-session-cookies --save-cookies=#{cookieFile} "#{repoSite}?service=files&t=#{repoId}" -O #{junkFile})
  end

  execute "download #{remoteFile} as #{localFile} with session cookies" do
    cwd tdir
    command %Q(#{wget} -O #{localFile} --referer=#{repoSite} --cookies=on --load-cookies=#{cookieFile} --keep-session-cookies --save-cookies=#{cookieFile} #{remoteFile})
  end
}