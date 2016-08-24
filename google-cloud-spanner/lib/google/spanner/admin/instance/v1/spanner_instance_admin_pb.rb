# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/spanner/admin/instance/v1/spanner_instance_admin.proto

require 'google/protobuf'

require 'google/api/annotations_pb'
require 'google/longrunning/operations_pb'
require 'google/protobuf/empty_pb'
require 'google/protobuf/timestamp_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "google.spanner.admin.instance.v1.InstanceConfig" do
    optional :name, :string, 1
    optional :display_name, :string, 2
  end
  add_message "google.spanner.admin.instance.v1.Instance" do
    optional :name, :string, 1
    optional :config, :string, 2
    optional :display_name, :string, 3
    optional :node_count, :int32, 5
    optional :state, :enum, 6, "google.spanner.admin.instance.v1.Instance.State"
    map :labels, :string, :string, 7
  end
  add_enum "google.spanner.admin.instance.v1.Instance.State" do
    value :STATE_UNSPECIFIED, 0
    value :CREATING, 1
    value :READY, 2
  end
  add_message "google.spanner.admin.instance.v1.ListInstanceConfigsRequest" do
    optional :name, :string, 1
    optional :page_size, :int32, 2
    optional :page_token, :string, 3
  end
  add_message "google.spanner.admin.instance.v1.ListInstanceConfigsResponse" do
    repeated :instance_configs, :message, 1, "google.spanner.admin.instance.v1.InstanceConfig"
    optional :next_page_token, :string, 2
  end
  add_message "google.spanner.admin.instance.v1.GetInstanceConfigRequest" do
    optional :name, :string, 1
  end
  add_message "google.spanner.admin.instance.v1.GetInstanceRequest" do
    optional :name, :string, 1
  end
  add_message "google.spanner.admin.instance.v1.ListInstancesRequest" do
    optional :name, :string, 1
    optional :page_size, :int32, 2
    optional :page_token, :string, 3
    optional :filter, :string, 4
  end
  add_message "google.spanner.admin.instance.v1.ListInstancesResponse" do
    repeated :instances, :message, 1, "google.spanner.admin.instance.v1.Instance"
    optional :next_page_token, :string, 2
  end
  add_message "google.spanner.admin.instance.v1.DeleteInstanceRequest" do
    optional :name, :string, 1
  end
  add_message "google.spanner.admin.instance.v1.CreateInstanceMetadata" do
    optional :instance, :message, 1, "google.spanner.admin.instance.v1.Instance"
    optional :start_time, :message, 2, "google.protobuf.Timestamp"
    optional :cancel_time, :message, 3, "google.protobuf.Timestamp"
    optional :end_time, :message, 4, "google.protobuf.Timestamp"
  end
  add_message "google.spanner.admin.instance.v1.UpdateInstanceMetadata" do
    optional :instance, :message, 1, "google.spanner.admin.instance.v1.Instance"
    optional :start_time, :message, 2, "google.protobuf.Timestamp"
    optional :cancel_time, :message, 3, "google.protobuf.Timestamp"
    optional :end_time, :message, 4, "google.protobuf.Timestamp"
  end
end

module Google
  module Spanner
    module Admin
      module Instance
        module V1
          InstanceConfig = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.InstanceConfig").msgclass
          Instance = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.Instance").msgclass
          Instance::State = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.Instance.State").enummodule
          ListInstanceConfigsRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.ListInstanceConfigsRequest").msgclass
          ListInstanceConfigsResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.ListInstanceConfigsResponse").msgclass
          GetInstanceConfigRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.GetInstanceConfigRequest").msgclass
          GetInstanceRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.GetInstanceRequest").msgclass
          ListInstancesRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.ListInstancesRequest").msgclass
          ListInstancesResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.ListInstancesResponse").msgclass
          DeleteInstanceRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.DeleteInstanceRequest").msgclass
          CreateInstanceMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.CreateInstanceMetadata").msgclass
          UpdateInstanceMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.instance.v1.UpdateInstanceMetadata").msgclass
        end
      end
    end
  end
end
