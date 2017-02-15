# Copyright 2016 Google Inc. All rights reserved.
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


require "google/cloud/spanner/instance/config/list"

module Google
  module Cloud
    module Spanner
      class Instance
        ##
        # # Instance Config
        #
        # ...
        #
        # See {Google::Cloud#spanner}
        #
        # @example
        #   require "google/cloud"
        #
        #   gcloud = Google::Cloud.new
        #   spanner = gcloud.spanner
        #
        #   # ...
        class Config
          ##
          # @private Creates a new Instance::Config instance.
          def initialize grpc
            @grpc = grpc
          end

          # The unique identifier for the project.
          # @return [String]
          def project_id
            Admin::Instance::V1::InstanceAdminClient
              .match_project_from_instance_config_name @grpc.name
          end

          ##
          # A unique identifier for the instance configuration.
          # @return [String]
          def instance_config_id
            Admin::Instance::V1::InstanceAdminClient
              .match_instance_config_from_instance_config_name @grpc.name
          end

          ##
          # The full path for the instance config resource. Values are of the
          # form `projects/<project_id>/instanceConfigs/<instance_config_id>`.
          # @return [String]
          def path
            @grpc.name
          end

          ##
          # The name of this instance configuration as it appears in UIs.
          # @return [String]
          def name
            @grpc.display_name
          end
          alias_method :display_name, :name

          ##
          # @private Creates a new Instance::Config instance from a
          # Google::Spanner::Admin::Instance::V1::InstanceConfig.
          def self.from_grpc grpc
            new grpc
          end

          protected

          ##
          # @private Raise an error unless an active connection to the service
          # is available.
          def ensure_service!
            fail "Must have active connection to service" unless service
          end
        end
      end
    end
  end
end
