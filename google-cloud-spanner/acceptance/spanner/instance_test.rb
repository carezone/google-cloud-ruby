# Copyright 2017 Google Inc. All rights reserved.
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

require "spanner_helper"

describe "Spanner Instances", :spanner do
  it "creates, updates, and deletes an instance" do
    instance_id = "#{$spanner_prefix}-crud"
    name = "gcloud-ruby Empty Instance"
    config = "regional-us-central1"

    spanner.instance(instance_id).must_be :nil?

    job = spanner.create_instance instance_id, name: name, config: config, nodes: 1, labels: { env: :development }

    job.must_be_kind_of Google::Cloud::Spanner::Instance::Job
    job.wont_be :done?
    job.wait_until_done!

    job.must_be :done?
    instance = job.instance
    instance.wont_be :nil?
    instance.must_be_kind_of Google::Cloud::Spanner::Instance
    instance.instance_id.must_equal instance_id
    instance.name.must_equal name
    instance.config.instance_config_id.must_equal config
    instance.nodes.must_equal 1
    instance.labels.to_h.must_equal({ "env" => "development" })

    spanner.instance(instance_id).wont_be :nil?

    new_name = instance.name.reverse
    instance.name = new_name
    instance.nodes = 2
    instance.labels["env"] = "production"
    instance.save

    instance.name.must_equal new_name
    instance.nodes.must_equal 2
    instance.labels.to_h.must_equal({ "env" => "production" })

    instance.delete
    spanner.instance(instance_id).must_be :nil?
  end
end
