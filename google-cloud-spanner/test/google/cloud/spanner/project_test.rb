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

describe Google::Cloud::Spanner::Project, :mock_spanner do
  it "knows the project identifier" do
    spanner.must_be_kind_of Google::Cloud::Spanner::Project
    spanner.project_id.must_equal project
  end

  it "builds an instance" do
    instance = spanner.instance "my-instance-id"

    instance.must_be_kind_of Google::Cloud::Spanner::Instance
    instance.instance_id.must_equal "my-instance-id"
  end

  it "builds an instance with the default id" do
    ENV.stub :[], "my-instance-id", ["SPANNER_INSTANCE"] do
      instance = spanner.instance

      instance.must_be_kind_of Google::Cloud::Spanner::Instance
      instance.instance_id.must_equal "my-instance-id"
    end
  end
end
