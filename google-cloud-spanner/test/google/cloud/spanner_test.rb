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

describe Google::Cloud do
  describe "#spanner" do
    it "calls out to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, client_config: nil) {
        project.must_equal nil
        keyfile.must_equal nil
        scope.must_be :nil?
        timeout.must_be :nil?
        client_config.must_be :nil?
        "spanner-project-object-empty"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner
        project.must_equal "spanner-project-object-empty"
      end
    end

    it "passes project and keyfile to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new "project-id", "keyfile-path"
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, client_config: nil) {
        project.must_equal "project-id"
        keyfile.must_equal "keyfile-path"
        scope.must_be :nil?
        timeout.must_be :nil?
        client_config.must_be :nil?
        "spanner-project-object"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner
        project.must_equal "spanner-project-object"
      end
    end

    it "passes project and keyfile and options to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new "project-id", "keyfile-path"
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, client_config: nil) {
        project.must_equal "project-id"
        keyfile.must_equal "keyfile-path"
        scope.must_equal "http://example.com/scope"
        timeout.must_equal 60
        client_config.must_equal({ "gax" => "options" })
        "spanner-project-object-scoped"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner scope: "http://example.com/scope", timeout: 60, client_config: { "gax" => "options" }
        project.must_equal "spanner-project-object-scoped"
      end
    end
  end

  describe ".spanner" do
    let(:default_credentials) { OpenStruct.new empty: true }
    let(:found_credentials) { "{}" }

    it "gets defaults for project_id and keyfile" do
      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud::Core::Environment.stub :project_id, "project-id" do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud.spanner
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.credentials.must_equal default_credentials
          end
        end
      end
    end

    it "uses provided project_id and keyfile" do
      stubbed_credentials = ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_equal nil
        "spanner-credentials"
      }
      stubbed_service = ->(project, credentials, timeout: nil, client_config: nil) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        client_config.must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud.spanner "project-id", "path/to/keyfile.json"
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end
  end

  describe "Spanner.new" do
    let(:default_credentials) { OpenStruct.new empty: true }
    let(:found_credentials) { "{}" }

    it "gets defaults for project_id and keyfile" do
      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud::Core::Environment.stub :project_id, "project-id" do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.credentials.must_equal default_credentials
          end
        end
      end
    end

    it "uses provided project_id and keyfile" do
      stubbed_credentials = ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_equal nil
        "spanner-credentials"
      }
      stubbed_service = ->(project, credentials, timeout: nil, client_config: nil) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        client_config.must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new project: "project-id", keyfile: "path/to/keyfile.json"
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end
  end
end
