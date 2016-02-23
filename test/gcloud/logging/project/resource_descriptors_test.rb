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

require "helper"

describe Gcloud::Logging::Project, :resource_descriptors, :mock_logging do
  it "lists resource descriptors" do
    num_descriptors = 3

    mock = Minitest::Mock.new
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(num_descriptors)),
                [Google::Logging::V2::ListMonitoredResourceDescriptorsRequest]
    logging.service.logging = mock

    resource_descriptors = logging.resource_descriptors

    mock.verify

    resource_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    resource_descriptors.size.must_equal num_descriptors
  end

  it "lists resource descriptors with find_resource_descriptors alias" do
    num_descriptors = 3

    mock = Minitest::Mock.new
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(num_descriptors)),
                [Google::Logging::V2::ListMonitoredResourceDescriptorsRequest]
    logging.service.logging = mock

    resource_descriptors = logging.find_resource_descriptors

    mock.verify

    resource_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    resource_descriptors.size.must_equal num_descriptors
  end

  it "paginates resource descriptors" do
    first_list_req = Google::Logging::V2::ListMonitoredResourceDescriptorsRequest.new
    second_list_req = Google::Logging::V2::ListMonitoredResourceDescriptorsRequest.new(page_token: "next_page_token")

    mock = Minitest::Mock.new
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(3, "next_page_token")),
                [first_list_req]
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(2)),
                [second_list_req]
    logging.service.logging = mock

    first_descriptors = logging.resource_descriptors
    second_descriptors = logging.resource_descriptors token: first_descriptors.token

    mock.verify

    first_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    first_descriptors.count.must_equal 3
    first_descriptors.token.wont_be :nil?
    first_descriptors.token.must_equal "next_page_token"

    second_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    second_descriptors.count.must_equal 2
    second_descriptors.token.must_be :nil?
  end

  it "paginates resource descriptors with next? and next" do
    first_list_req = Google::Logging::V2::ListMonitoredResourceDescriptorsRequest.new
    second_list_req = Google::Logging::V2::ListMonitoredResourceDescriptorsRequest.new(page_token: "next_page_token")

    mock = Minitest::Mock.new
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(3, "next_page_token")),
                [first_list_req]
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(2)),
                [second_list_req]
    logging.service.logging = mock

    first_descriptors = logging.resource_descriptors
    second_descriptors = first_descriptors.next

    mock.verify

    first_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    first_descriptors.count.must_equal 3
    first_descriptors.next?.must_equal true #must_be :next?

    second_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    second_descriptors.count.must_equal 2
    second_descriptors.next?.must_equal false #wont_be :next?
  end

  it "paginates resource descriptors with max set" do
    list_req = Google::Logging::V2::ListMonitoredResourceDescriptorsRequest.new(page_size: 3)

    mock = Minitest::Mock.new
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(3, "next_page_token")),
                [list_req]
    logging.service.logging = mock

    resource_descriptors = logging.resource_descriptors max: 3

    mock.verify

    resource_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    resource_descriptors.count.must_equal 3
    resource_descriptors.token.wont_be :nil?
    resource_descriptors.token.must_equal "next_page_token"
  end

  it "paginates resource descriptors without max set" do
    list_req = Google::Logging::V2::ListMonitoredResourceDescriptorsRequest.new

    mock = Minitest::Mock.new
    mock.expect :list_monitored_resource_descriptors,
                Google::Logging::V2::ListMonitoredResourceDescriptorsResponse.decode_json(list_resource_descriptors_json(3, "next_page_token")),
                [list_req]
    logging.service.logging = mock

    resource_descriptors = logging.resource_descriptors

    mock.verify

    resource_descriptors.each { |m| m.must_be_kind_of Gcloud::Logging::ResourceDescriptor }
    resource_descriptors.count.must_equal 3
    resource_descriptors.token.wont_be :nil?
    resource_descriptors.token.must_equal "next_page_token"
  end

  def list_resource_descriptors_json count = 2, token = nil
    {
      resource_descriptors: count.times.map { random_resource_descriptor_hash },
      next_page_token: token
    }.delete_if { |_, v| v.nil? }.to_json
  end
end