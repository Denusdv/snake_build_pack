# Encoding: utf-8
# IBM WebSphere Application Server Liberty Buildpack
# Copyright 2014 the original author or authors.
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

module LibertyBuildpack::Container
  # Encapsulates the mapping from optional Liberty Bluemix component download
  # names to feature names, and to xpath expressions that will match if any of
  # the features are present in a server.xml feature element.
  #
  # The component names are used in the component_index.yml file pointed to by
  # the index.yml file (except when the index.yml points directly to an
  # all-in-one Liberty download). The index.yml file is pointed to by the
  # buildpack's liberty.yml file.

  class OptionalComponents

    private

      CONFIG_FILE = '../../../config/liberty.yml'.freeze

      def self.initialize
        config = YAML.load_file(File.expand_path(CONFIG_FILE, File.dirname(__FILE__)))
        @@configuration = config['component_feature_map'] || {}
      end

      # Return an xpath string of the form,
      # "/server/featureManager/feature[. = 'x' or . = 'y']/node()"
      def self.feature_names_to_feature_xpath(feature_names)
        "/server/featureManager/feature[. = '" << feature_names.join("' or . = '") << "']/node()"
      end

      initialize

    public

      # A map of Liberty Bluemix component name to an array of feature names
      # that the component provides.
      COMPONENT_NAME_TO_FEATURE_NAMES = @@configuration

      # A map of Liberty Bluemix component name to an XPath expression string
      # that may be used query against the contents of a server.xml file to
      # select any of the features that the component provides. Thus a non-empty
      # result indicates that the server requires one or more features that the
      # component provides.
      COMPONENT_NAME_TO_FEATURE_XPATH = Hash[COMPONENT_NAME_TO_FEATURE_NAMES.map { |k, v| [k, feature_names_to_feature_xpath(v)] }].freeze

  end

end
