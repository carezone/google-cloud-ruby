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


require "delegate"

module Google
  module Cloud
    module Spanner
      class Instance
        ##
        # Instance::List is a special case Array with additional
        # values.
        class List < DelegateClass(::Array)
          ##
          # If not empty, indicates that there are more records that match
          # the request and this value should be passed to continue.
          attr_accessor :token

          ##
          # @private Create a new Instance::List with an array of
          # Instance instances.
          def initialize arr = []
            super arr
          end

          ##
          # Whether there is a next page of instances.
          #
          # @return [Boolean]
          #
          # @example
          #   require "google/cloud/spanner"
          #
          #   spanner = Google::Cloud::Spanner.new
          #
          #   instances = spanner.instances
          #   if instances.next?
          #     next_instances = instances.next
          #   end
          def next?
            !token.nil?
          end

          ##
          # Retrieve the next page of instances.
          #
          # @return [Instance::List]
          #
          # @example
          #   require "google/cloud/spanner"
          #
          #   spanner = Google::Cloud::Spanner.new
          #
          #   instances = spanner.instances
          #   if instances.next?
          #     next_instances = instances.next
          #   end
          def next
            return nil unless next?
            ensure_service!
            options = { token: token, max: @max }
            grpc = @service.list_instances options
            self.class.from_grpc grpc, @service, @max
          end

          ##
          # Retrieves all instances by repeatedly loading {#next} until {#next?}
          # returns `false`. Calls the given block once for each instance
          # instance, which is passed as the parameter.
          #
          # An Enumerator is returned if no block is given.
          #
          # This method may make several API calls until all instances are
          # retrieved. Be sure to use as narrow a search criteria as possible.
          # Please use with caution.
          #
          # @param [Integer] request_limit The upper limit of API requests to
          #   make to load all instances. Default is no limit.
          # @yield [instance] The block for accessing each instance.
          # @yieldparam [Instance] instance The instance object.
          #
          # @return [Enumerator]
          #
          # @example Iterating each instance by passing a block:
          #   require "google/cloud/spanner"
          #
          #   spanner = Google::Cloud::Spanner.new
          #
          #   spanner.instances.all do |instance|
          #     puts instance.name
          #   end
          #
          # @example Using the enumerator by not passing a block:
          #   require "google/cloud/spanner"
          #
          #   spanner = Google::Cloud::Spanner.new
          #
          #   all_instance_ids = spanner.instances.all.map do |instance|
          #     instance.name
          #   end
          #
          # @example Limit the number of API calls made:
          #   require "google/cloud/spanner"
          #
          #   spanner = Google::Cloud::Spanner.new
          #
          #   spanner.instances.all(request_limit: 10) do |instance|
          #     puts instance.name
          #   end
          #
          def all request_limit: nil
            request_limit = request_limit.to_i if request_limit
            unless block_given?
              return enum_for(:all, request_limit: request_limit)
            end
            results = self
            loop do
              results.each { |r| yield r }
              if request_limit
                request_limit -= 1
                break if request_limit < 0
              end
              break unless results.next?
              results = results.next
            end
          end

          ##
          # @private New Instance::List from a
          # Google::Spanner::Admin::Instance::V1::ListInstancesResponse
          # object.
          def self.from_grpc grpc, service, max = nil
            instances = List.new(Array(grpc.instances).map do |instance|
              Instance.from_grpc instance, service
            end)
            token = grpc.next_page_token
            token = nil if token == ""
            instances.instance_variable_set :@token,   token
            instances.instance_variable_set :@service, service
            instances.instance_variable_set :@max,     max
            instances
          end

          protected

          ##
          # Raise an error unless an active service is available.
          def ensure_service!
            fail "Must have active connection" unless @service
          end
        end
      end
    end
  end
end
