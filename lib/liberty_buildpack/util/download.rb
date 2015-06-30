# Encoding: utf-8
# IBM WebSphere Application Server Liberty Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'liberty_buildpack/util'
require 'liberty_buildpack/util/application_cache'
require 'liberty_buildpack/util/format_duration'

module LibertyBuildpack::Util

  # Downloads a given item using the application cache.
  #
  # @param [LibertyBuildpack::Util::TokenizedVersion] version the version of the item
  # @param [String] uri the URI of the item
  # @param [String] description a description of the item
  # @param [String] jar_name the filename of the item
  # @param [String] target_directory the path of the directory into which to download the item
  def self.download(version, uri, description, jar_name, target_directory)

    download_start_time = Time.now
    print "-----> Downloading #{description} #{version} from #{uri} "

    LibertyBuildpack::Util::ApplicationCache.new.get(uri) do |file| # TODO: Use global cache #50175265
      FileUtils.cp(file.path, File.join(target_directory, jar_name))
      puts "(#{(Time.now - download_start_time).duration})"
    end

  end

end
